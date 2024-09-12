import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:recce/blocs/form_cubit.dart';
import 'package:recce/blocs/network_cubit.dart';
import 'package:recce/components/component.dart';
import 'package:recce/components/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:recce/views/widgets/nointernet_widget.dart';

class FormScreen extends StatelessWidget {
  final Map<String, dynamic>? mapArgs;

  const FormScreen({super.key, this.mapArgs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => FormCubit()..loadForm(),
        child: FormView(
          mapJson: mapArgs!['collectionJson'],
          formName: mapArgs!['formName'],
          position: mapArgs!['position'],
          id: mapArgs!['id'],
        ),
      ),
    );
  }
}

class FormView extends StatelessWidget {
  final Map<String, dynamic>? mapJson;
  final String? formName;
  final Position? position;
  final String? id;

  const FormView(
      {super.key, this.mapJson, this.formName, this.position, this.id});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return _showExitConfirmationDialog(context);
      },
      child: BlocConsumer<NetworkCubit,NetworkState>(

        listener: (context,networkState) {
           if (networkState is NetworkDisconnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No Internet Connection'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, networkState) {
          if (networkState is NetworkConnected) {
          return BlocConsumer<FormCubit, FormStates>(
            listener: (context, state) {
              // if (state is FormLoading) {
              //   const Center(child: CircularProgressIndicator());
              // }
              if (state is FormSubmitted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text('Form submitted: ${state.formData.message}'),
                  ),
                );
                Navigator.pushNamed(context, '/home_screen');
              } else if (state is FormError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text('Error: ${state.message}'),
                  ),
                );
          
                Navigator.pushNamed(context, '/home_screen');
              }
            },
            builder: (context, state) {
              if (state is FormLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  backgroundColor: AppColors.primary,
                ));
              } else if (state is FormUpLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: CircularPercentIndicator(
                        animationDuration: 200,
                        // animation: true,
                        radius: 50.0,
                        lineWidth: 10.0,
                        percent: state.progress,
                        center:
                            Text('${(state.progress * 100).toStringAsFixed(0)}%'),
                        progressColor: AppColors.primary,
                      )),
                      // CircularProgressIndicator(
                      //   value: state.progress,
                      //   backgroundColor: AppColors.primary,
                      // ),
                      //  const SizedBox(height: 16),
                      //  Text('${(state.progress * 100).toStringAsFixed(0)}% uploaded',style: const TextStyle(fontSize: 16),),
                    ],
                  ),
                );
              } else if (state is FormLoaded) {
                return FormWidget(
                  formData: mapJson,
                  formName: formName,
                  currentPosition: position,
                  id: id,
                );
              } else if (state is FormError) {
                return Center(child: Text(state.message));
              }
              return const Center(
                  child: Text(
                'Please wait...',
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ));
            },
          );
        } else if (networkState is NetworkDisconnected) {
            return NoInternetWidget(
              onRetry: () {
                context.read<NetworkCubit>();
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you want to Exit?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false if user cancels
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if user confirms
              },
            ),
          ],
        );
      },
    ); // Ensure that the result is a boolean
    return result ??
        false; // Return false if result is null // Return false if dialog is dismissed
  }
}

@immutable
class FormWidget extends StatefulWidget {
  final Map<String, dynamic>? formData;
  final String? formName;
  final Position? currentPosition;
  final String? id;

  const FormWidget(
      {super.key, this.currentPosition, this.formData, this.formName, this.id});

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formValues;
  //final Map<String, FocusNode> _focusNodes = {}; // Store focus nodes
  final ScrollController _scrollController = ScrollController();
  late String formName;
  int _currentSection = 0;
  final Map<String, PhotoPickerData> _photoPickerData = {};
  final List<String> _schoolNames = [];
  String? _schoolName; // Define _schoolNames here
  String? validatemessage;

  @override
  void initState() {
    super.initState();
    _formValues = {};
    _formValues['latitude'] = widget.currentPosition!.latitude;
    _formValues['longitude'] = widget.currentPosition!.longitude;
    formName = widget.formName ?? 'Form';

    // Initialize focus nodes for each field
    // widget.formData!['sections'].forEach((section) {
    //   section['fields'].forEach((field) {
    //     _focusNodes[field['id']] = FocusNode();
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final sections = widget.formData!['sections'] as List;
    final currentSectionData = sections[_currentSection];
    final fields = currentSectionData['fields'] as List;

    return Scaffold(
      appBar: CustomAppbar(
        title: formName,
        backbutton: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      currentSectionData['title'] ??
                          'Section ${_currentSection + 1}',
                      style: AppStyles.heading3(context, AppColors.primary, 12),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ...fields.map((field) {
                        switch (field['type']) {
                          case 'photo_picker':
                            return _buildPhotoPickerField(field);
                          case 'udise':
                            return _buildUdiseField(field);

                          case 'date_picker':
                            return _buildDatePickerField(field);

                          case 'text':
                            // Initialize the controller with the current value from the form values map
                            TextEditingController controller =
                                TextEditingController(
                              text: _formValues[field['id']] ?? '',
                            );

                            return Column(
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),
                                CustomTextFormField(
                                  maxlines: field['maxlines'] ?? 1,
                                  textController:
                                      controller, // Assign the controller
                                  labelText: field['hintText'],
                                  validator: (value) {
                                    if (field['validation']?['required'] ==
                                            true &&
                                        value?.isEmpty == true) {
                                      return 'This field is required';
                                    }
                                    if (field['validation']?['pattern'] !=
                                        null) {
                                      final regex = RegExp(
                                          field['validation']['pattern']);
                                      if (!regex.hasMatch(value ?? '')) {
                                        return 'Invalid format';
                                      }
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _formValues[field['id']] = value;
                                    // FocusScope.of(context)
                                    //     .unfocus(); //use this to dismiss the screen keyboard

                                    // setState(() {});
                                    return;
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          case 'landline':
                            // Initialize the controller with the current value from the form values map
                            TextEditingController controller0 =
                                TextEditingController(
                              text: _formValues[field['id']] ?? '',
                            );

                            return Column(
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),
                                CustomTextFormField(
                                  textController:
                                      controller0, // Assign the controller
                                  labelText: field['hintText'],
                                  textInputType: TextInputType
                                      .phone, // Landline number keyboard
                                  validator: (value) {
                                    if (field['validation']?['required'] ==
                                            true &&
                                        value?.isEmpty == true) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _formValues[field['id']] = value;
                                    return;
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            );

                          case 'phone':
                            // Initialize the controller with the current value from the form values map
                            TextEditingController controller0 =
                                TextEditingController(
                              text: _formValues[field['id']] ?? '',
                            );

                            return Column(
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),
                                CustomTextFormField(
                                  maxlength: 10,
                                  textController:
                                      controller0, // Assign the controller
                                  labelText: field['hintText'],
                                  textInputType: TextInputType
                                      .phone, // Phone number keyboard
                                  validator: (value) {
                                    if (field['validation']?['required'] ==
                                            true &&
                                        value?.isEmpty == true) {
                                      return 'This field is required';
                                    }
                                    final regex = RegExp(
                                        r'^\+91\s?\d{10}$|^91\d{10}$|^\d{10}$');
                                    if (!regex.hasMatch(value ?? '')) {
                                      return 'Invalid phone number format';
                                    }
                                    return null;
                                  },

                                  onChanged: (value) {
                                    _formValues[field['id']] = value;
                                    return;
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            );

                          case 'number':
                            // Initialize the controller with the current value from the form values map
                            TextEditingController controller0 =
                                TextEditingController(
                              text: _formValues[field['id']] ?? '',
                            );

                            return Column(
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),
                                CustomTextFormField(
                                  textController:
                                      controller0, // Assign the controller
                                  labelText:
                                      field['hintText'], // Label for the field
                                  textInputType:
                                      TextInputType.number, // Numeric keyboard
                                  validator: (value) {
                                    if (field['validation']?['required'] ==
                                            true &&
                                        value?.isEmpty == true) {
                                      return 'This field is required'; // Validation for required field
                                    }
                                    return null; // No validation error
                                  },
                                  onChanged: (value) {
                                    _formValues[field['id']] =
                                        value; // Capture input value
                                  },
                                ),

                                // CustomTextFormField(
                                //   textController:
                                //       controller0, // Assign the controller
                                //   labelText: field['hintText'],
                                //   textInputType:
                                //       TextInputType.number, // Numeric keyboard
                                //   validator: (value) {
                                //     if (field['validation']?['required'] ==
                                //             true &&
                                //         value?.isEmpty == true) {
                                //       return 'This field is required';
                                //     }
                                //     return null;
                                //   },
                                //   onChanged: (value) {
                                //     _formValues[field['id']] = value;
                                //     return null;
                                //   },
                                // ),
                                const SizedBox(height: 20),
                              ],
                            );
                          case 'time_picker':
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () async {
                                          TimeOfDay? selectedTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );

                                          if (selectedTime != null) {
                                            setState(() {
                                              _formValues['start_id'] =
                                                  selectedTime.format(context);
                                            });
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: CustomTextFormField(
                                            labelText: 'Start Time',
                                            textController:
                                                TextEditingController(
                                              text: _formValues['start_id'],
                                            ),
                                            validator: (value) {
                                              if (value?.isEmpty == true) {
                                                return 'Please select a start time';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () async {
                                          TimeOfDay? selectedTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );

                                          if (selectedTime != null) {
                                            setState(() {
                                              _formValues['end_id'] =
                                                  selectedTime.format(context);
                                            });
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: CustomTextFormField(
                                            labelText: 'End Time',
                                            textController:
                                                TextEditingController(
                                              text: _formValues['end_id'],
                                            ),
                                            validator: (value) {
                                              if (value?.isEmpty == true) {
                                                return 'Please select an end time';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          case 'device_count':
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                  label: field[
                                      'labelText'], // Display the label for this section
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),

                                // Table Header
                                const Row(
                                  children: [
                                    Expanded(child: Text('Device Type',style: TextStyle(fontWeight: FontWeight.bold,),)),
                                    Expanded(child: Text('Total Devices',style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('Working Devices',style: TextStyle(fontWeight: FontWeight.bold),)),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // Iterate over each device type
                                ...field['deviceTypes']
                                    .map<Widget>((deviceType) {
                                  TextEditingController totalController =
                                      TextEditingController(
                                    text: _formValues[
                                            'total_${deviceType['id']}'] ??
                                        '',
                                  );
                                  TextEditingController workingController =
                                      TextEditingController(
                                    text: _formValues[
                                            'working_${deviceType['id']}'] ??
                                        '',
                                  );

                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(deviceType[
                                                'label'],style: const TextStyle(fontWeight: FontWeight.bold)), // Display the device name
                                          ),
                                          Expanded(
                                            child: CustomTextFormField(
                                              textController: totalController,
                                              labelText: 'Total',
                                              textInputType: TextInputType.number,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Field required'; // Validation for total devices
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _formValues[
                                                        'total_${deviceType['id']}'] =
                                                    value;
                                              
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 15,),
                                          Expanded(
                                            child: CustomTextFormField(
                                              textController: workingController,
                                              labelText: 'Working',
                                              textInputType: TextInputType.number,
                                              validator: (value) {
                                                int total = int.tryParse(_formValues[
                                                            'total_${deviceType['id']}'] ??
                                                        '') ??
                                                    0;
                                                int working =
                                                    int.tryParse(value ?? '') ?? 0;
                                      
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Field required'; // Validation for working devices
                                                } else if (working > total) {
                                                  return 'Cannot exceed total devices'; // Validation for working devices
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _formValues[
                                                        'working_${deviceType['id']}'] =
                                                    value;
                                              
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15,)
                                    ],
                                  );
                                  
                                }).toList(),
                              ],
                            );

                          case 'year_picker':
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () async {
                                    final selectedYear = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return YearPickerDialog(
                                          initialYear:
                                              _formValues[field['id']] != null
                                                  ? int.parse(
                                                      _formValues[field['id']])
                                                  : DateTime.now().year,
                                          startYear: field['year'],
                                          endYear: DateTime.now().year,
                                        );
                                      },
                                    );

                                    if (selectedYear != null) {
                                      setState(() {
                                        _formValues[field['id']] =
                                            selectedYear.toString();
                                      });
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: CustomTextFormField(
                                      readOnly: true,
                                      labelText: field['hintText'] as String,
                                      textController: TextEditingController(
                                        text: _formValues[field['id']],
                                      ),
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return 'Please select a year';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );

                          case 'teacher_count':
                            return _buildTeacherFields();
                          case 'dropdown':
                            // Initialize the controller for the "other_specify" field if needed
                            TextEditingController specifyController =
                                TextEditingController(
                              text: _formValues['other_specify'] ?? '',
                            );

                            return Column(children: [
                              LabelText(
                                label: field['labelText'],
                                astrick: true,
                              ),
                              const SizedBox(height: 10),
                              CustomDropdownFormField(
                                options: List<String>.from(field['options']),
                                selectedOption:
                                    _formValues[field['id']] as String?,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select an option';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _formValues[field['id']] = value;

                                    // Clear the "other_specify" value if "other" is not selected
                                    if (value != 'other') {
                                      _formValues['other_specify'] = null;
                                      specifyController.clear();
                                    }
                                  });
                                },
                                labelText: field['hintText'] as String,
                              ),
                              if (_formValues[field['id']] == 'Other')
                                Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    LabelText(
                                      label: 'Specify Other',
                                      astrick: true,
                                    ),
                                    const SizedBox(height: 10),
                                    CustomTextFormField(
                                      textController:
                                          specifyController, // Assign the controller
                                      labelText: 'Please specify',
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return 'Please specify';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        _formValues['other_specify'] = value;
                                        return;
                                      },
                                    ),
                                  ],
                                ),
                            ]);

                          case 'dropdown1':
                            TextEditingController specifyController =
                                TextEditingController(
                              text: _formValues['other_specify'] ?? '',
                            );
                            List<String> generateYearList(int startYear) {
                              int currentYear = DateTime.now().year;
                              List<String> yearList = [];

                              for (int year = startYear;
                                  year <= currentYear;
                                  year++) {
                                yearList.add(year.toString());
                              }

                              return yearList;
                            }
                            List<String> yearOptions = [];
                            if (field['year'] != null) {
                              yearOptions = generateYearList(field['year']);
                            }

                            return Column(
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),
                                CustomDropdownFormField(
                                  options:
                                      yearOptions, // Use the generated year list
                                  selectedOption:
                                      _formValues[field['id']] as String?,
                                  onChanged: (value) {
                                    setState(() {
                                      _formValues[field['id']] = value;

                                      if (value != 'other') {
                                        _formValues['other_specify'] = null;
                                        specifyController.clear();
                                      }
                                    });
                                  },
                                  labelText: field['hintText'] as String,
                                ),
                                if (_formValues[field['id']] == 'Other')
                                  Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      LabelText(
                                        label: 'Specify Other',
                                        astrick: true,
                                      ),
                                      const SizedBox(height: 10),
                                      CustomTextFormField(
                                        textController: specifyController,
                                        labelText: 'Please specify',
                                        validator: (value) {
                                          if (value?.isEmpty == true) {
                                            return 'Please specify';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          _formValues['other_specify'] = value;
                                          return;
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          case 'checkbox':
                            List<dynamic> options =
                                List<dynamic>.from(field['options'] ?? []);
                            List<dynamic> selectedValues = [];
                            final bool isRequired =
                                field['validation']?['required'] ?? false;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: isRequired,
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: options.map<Widget>((option) {
                                    return CheckboxListTile(
                                      activeColor: AppColors.primary,
                                      title: Text(option),
                                      value: _formValues[field['id']]
                                              ?.contains(option) ??
                                          false,
                                      onChanged: (value) {
                                        selectedValues =
                                            _formValues[field['id']] ?? [];
                                        if (value == true) {
                                          selectedValues.add(option);
                                        } else {
                                          selectedValues.remove(option);
                                        }

                                        setState(() {
                                          _formValues[field['id']] =
                                              selectedValues;
                                          // Validation: if the field is required and no option is selected, show the error message
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                                // Display the validation message if there is one
                                if (validatemessage != null)
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      validatemessage!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                const SizedBox(height: 20),
                              ],
                            );

                          case 'type_digital_learning':
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: (field['options'] as List<dynamic>)
                                      .map<Widget>((option) {
                                    final isSelected = (_formValues[field['id']]
                                                as List<String>?)
                                            ?.contains(option) ??
                                        false;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CheckboxListTile(
                                          title: Text(option),
                                          value: isSelected,
                                          onChanged: (value) {
                                            final selectedValues =
                                                _formValues[field['id']]
                                                        as List<String>? ??
                                                    [];

                                            // Handle selection/deselection
                                            if (value == true) {
                                              selectedValues.add(option);

                                              // If "No" is selected, clear other selections
                                              if (option == 'No') {
                                                selectedValues.clear();
                                                selectedValues.add('No');
                                              } else {
                                                // If anything other than "No" is selected, remove "No" from selections
                                                selectedValues.remove('No');
                                              }
                                            } else {
                                              selectedValues.remove(option);
                                            }

                                            setState(() {
                                              _formValues[field['id']] =
                                                  selectedValues;
                                            });
                                          },
                                        ),
                                        if (isSelected && option != 'No')
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, top: 8.0),
                                            child: _buildPhotoPickerField(field[
                                                option
                                                    .toLowerCase()
                                                    .replaceAll(' ', '_')]),
                                          ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );

                          case 'tank_and_number':
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: (field['options'] as List<dynamic>)
                                      .map<Widget>((option) {
                                    final isSelected = (_formValues[field['id']]
                                                as List<String>?)
                                            ?.contains(option) ??
                                        false;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CheckboxListTile(
                                          title: Text(option),
                                          value: isSelected,
                                          onChanged: (value) {
                                            final selectedValues =
                                                _formValues[field['id']]
                                                        as List<String>? ??
                                                    [];
                                            if (value == true) {
                                              selectedValues.add(option);
                                            } else {
                                              selectedValues.remove(option);
                                            }
                                            setState(() {
                                              _formValues[field['id']] =
                                                  selectedValues;
                                            });
                                          },
                                        ),
                                        if (isSelected)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, top: 8.0),
                                            child: CustomTextFormField(
                                              labelText: 'Number of $option',
                                              textInputType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value?.isEmpty == true) {
                                                  return 'Please enter the number of $option';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _formValues[
                                                        'num_${option.replaceAll(' ', '_')}'] =
                                                    value;
                                              },
                                            ),
                                          ),
                                        if (isSelected)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, top: 8.0),
                                            child: _buildPhotoPickerField(field[
                                                option
                                                    .toLowerCase()
                                                    .replaceAll(' ', '_')]),
                                          ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );

                          case 'radio':
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),

                                // Build the list of radio buttons
                                Column(children: [
                                  DynamicRadio(
                                    selectedOption:
                                        _formValues[field['id']] as String?,
                                    options:
                                        List<String>.from(field['options']),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _formValues[field['id']] = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (field['validation']['required'] ==
                                              true &&
                                          (value == null || value.isEmpty)) {
                                        return 'Please select an option';
                                      }
                                      return null;
                                    },
                                  )
                                  // DynamicRadio(selectedOption: field['i'], options: field['options'], onChanged: (String? ) {  },),
                                  // children: List<Widget>.from(
                                  //   field['options'].map<Widget>((option) {
                                  //     return RadioListTile<String>(
                                  //       title: Text(option),
                                  //       value: option,
                                  //       groupValue: _formValues[field['id']],
                                  //       onChanged: (value) {
                                  //         setState(() {
                                  //           _formValues[field['id']] = value;

                                  //           // Clear "other_specify" if "Other" is not selected
                                  //           // if (value != 'Other') {
                                  //           //   _formValues[field['otherOption']
                                  //           //       ['id']] = null;
                                  //           // }
                                  //         });
                                  //       },
                                  //     );
                                  //   }),
                                  // ),
                                ]),
                                const SizedBox(height: 20),

                                // Conditionally show the "Specify Other" text field
                                if (_formValues[field['id']] == 'Other')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LabelText(
                                        label: field['otherOption']
                                            ['labelText'],
                                        astrick: true,
                                      ),
                                      const SizedBox(height: 10),
                                      CustomTextFormField(
                                        textController: TextEditingController(
                                          text: _formValues[field['otherOption']
                                                  ['id']] ??
                                              '',
                                        ),
                                        labelText: 'Specify your option',
                                        validator: (value) {
                                          if (value?.isEmpty == true) {
                                            return 'Please specify';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            _formValues[field['otherOption']
                                                ['id']] = value;
                                          });
                                          return;
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            );

                          case 'radio_with_other':
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),
                                Column(children: [
                                  DynamicRadio(
                                    selectedOption:
                                        _formValues[field['id']] as String?,
                                    options:
                                        List<String>.from(field['options']),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _formValues[field['id']] = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (field['validation']['required'] ==
                                              true &&
                                          (value == null || value.isEmpty)) {
                                        return 'Please select an option';
                                      }
                                      return null;
                                    },
                                  )
                                  //    List<Widget>.from(
                                  //     field['options'].map<Widget>((option) {
                                  //   return RadioListTile<String>(
                                  //     title: Text(option),
                                  //     value: option,
                                  //     groupValue: _formValues[field['id']],
                                  //     onChanged: (value) {
                                  //       setState(() {
                                  //         _formValues[field['id']] = value;
                                  //         // Reset the "other" field if "Yes" is not selected
                                  //         if (value != 'Yes') {
                                  //           _formValues.remove(
                                  //               field['otherOption']['id']);
                                  //         }
                                  //       });
                                  //     },
                                  //   );
                                  // })),
                                ]),
                                if (_formValues[field['id']] == 'Yes') ...[
                                  (field['otherOption']['labelText'] != null &&
                                          field['otherOption']['labelText']
                                              .isNotEmpty)
                                      ? LabelText(
                                          label: field['otherOption']
                                              ['labelText'],
                                          astrick: true,
                                        )
                                      : const SizedBox(),
                                  const SizedBox(height: 10),
                                  _buildDynamicField(field['otherOption']),
                                ],
                                const SizedBox(height: 20),
                              ],
                            );

                          case 'number_with_suffix':
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFormField(
                                        labelText: field['hintText'],
                                        textInputType: TextInputType.number,
                                        validator: (value) {
                                          if (field['validation']
                                                      ?['required'] ==
                                                  true &&
                                              (value?.isEmpty ?? true)) {
                                            return 'This field is required';
                                          }
                                          final regex = RegExp(
                                              field['validation']?['pattern'] ??
                                                  r'^[0-9]+$');
                                          if (!regex.hasMatch(value ?? '')) {
                                            return field['validation']
                                                    ?['errorMessage'] ??
                                                'Invalid format';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          _formValues[field['id']] = value;
                                          return;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      field['suffixText'] ?? 'square meters',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            );

                          case 'playground_dimensions':
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelText(
                                  label: field['labelText'],
                                  astrick: true,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFormField(
                                        labelText: field['fields'][0][
                                            'labelText'], // Use the label from the JSON
                                        hintText: field['fields'][0][
                                            'hintText'], // Use the hint text from the JSON
                                        textInputType: TextInputType.number,
                                        validator: (value) {
                                          if (field['fields'][0]['validation']
                                                      ?['required'] ==
                                                  true &&
                                              value?.isEmpty == true) {
                                            return 'Field required';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          _formValues[field['fields'][0]
                                              ['id']] = value;
                                          return;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'X',
                                      style: AppStyles.heading3(
                                          context, AppColors.onBackground, 12),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomTextFormField(
                                        labelText: field['fields'][1][
                                            'labelText'], // Use the label from the JSON
                                        hintText: field['fields'][1][
                                            'hintText'], // Use the hint text from the JSON
                                        textInputType: TextInputType.number,
                                        validator: (value) {
                                          if (field['fields'][1]['validation']
                                                      ?['required'] ==
                                                  true &&
                                              value?.isEmpty == true) {
                                            return 'Field required';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          _formValues[field['fields'][1]
                                              ['id']] = value;
                                          return;
                                        },
                                      ),
                                    ),
                                    Text(
                                      'feet',
                                      style: AppStyles.heading3(
                                          context, AppColors.onBackground, 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            );

                          default:
                            return Container();
                        }
                      }),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (_currentSection > 0)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentSection--;
                                });
                              },
                              child: const Text('Back'),
                            ),
                          if (_currentSection < sections.length - 1)
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  setState(() {
                                    _currentSection++;
                                  });
                                }
                              },
                              child: const Text('Next'),
                            ),
                          if (_currentSection == sections.length - 1)
                            ElevatedButton(
                              style: AppStyles.primaryButtonStyle(
                                  context, AppColors.primary),
                              onPressed: () async {
                                bool isValid =
                                    true; // Track overall form validity

                                // Iterate through each section and its fields to perform validation
                                 // Iterate over each section
  widget.formData!['sections'].forEach((section) {
    // Iterate over each field in the section
    section['fields'].forEach((field) {
      // Recursively validate the field and its nested fields (if any)
      isValid = _validateField(field) && isValid;

      // Check for nested otherOption fields and validate them
      if (field.containsKey('otherOption') && field['otherOption'] is Map) {
        if(field['otherOption']['fields'] != null || field['otherOption']['fields'] == ''){
        final otherOptionFields = field['otherOption']['fields'] as List<dynamic>;
        for (var nestedField in otherOptionFields) {
          // Validate nested fields in otherOption
          isValid = _validateField(nestedField) && isValid;
        }
        }
      }
    });
  });
                                // Validate form before showing the confirmation dialog
                                if ((_formKey.currentState?.validate() ??
                                        false) &&
                                    isValid) {
                                  // Show confirmation dialog
                                  bool? confirmationResult = await showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Confirmation'),
                                      content:
                                          const Text('Do you want to submit?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('No'),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                false); // Return false if user cancels
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Yes'),
                                          onPressed: () {
                                            const CircularProgressIndicator();
                                            Navigator.of(context).pop(true);
                                            // Return true if user confirms
                                          },
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmationResult == true) {
                                    try {
                                      const CircularProgressIndicator();
                                      _formKey.currentState?.save();
                                      // Upload photos and submit the form
                                      context
                                          .read<FormCubit>()
                                          .uploadPhotosAndSubmitForm(
                                              _photoPickerData,
                                              _formValues,
                                              widget.id);
                                    } finally {
                                      // Stop loading indicator after submission
                                    }
                                  }
                                  // Save form data
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please check!! Some fields are missing'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  // Show error message if form validation fails
                                }
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(color: AppColors.background),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateField(Map<String, dynamic> field) {
    bool isValid = true;

    // Check if the field is a photo picker
    if (field['type'] == 'photo_picker' ) {
      print('Found the photo_picker');
      final bool isRequired = field['validation']?['required'] ?? false;
      final int minPhotos = field['validation']?['minPhotos'] ?? 0;

      // Get the photo picker data for this field
      final photoPickerData = _photoPickerData[field['id']];

      // Perform photo picker validation
      if (photoPickerData == null || photoPickerData.photos.isEmpty) {
        if (isRequired) {
          isValid = false;
          print('Field ${field['labelText']} is required.');
        }
      } else if (photoPickerData.photos.length < minPhotos) {
        isValid = false;
        print(
            'Field ${field['labelText']} requires at least $minPhotos photos.');
      }
    }

    // Check if the field is a checkbox
    if (field['type'] == 'checkbox') {
      print('Found the checkbox');
      final bool isRequired = field['validation']?['required'] ?? false;

      // Get the checkbox data for this field
      final selectedValues = _formValues[field['id']] ?? [];

      // Perform checkbox validation
      if (isRequired && selectedValues.isEmpty) {
        isValid = false;
      
      setState(() {
         validatemessage =
            'Field ${field['labelText']} requires at least one option to be selected.';
      });
       
      } else {
        setState(() {
           validatemessage = null;
        validatemessage = '';
        });
       
      }
    }

    // Check if the field has an 'otherOption' with nested fields
    if (field.containsKey('otherOption') &&
        field['type'] == 'checkbox' &&
        field['otherOption'] is Map) {
      final otherOptionFields = field['otherOption']['fields'] as List<dynamic>;
      for (var nestedField in otherOptionFields) {
        print('Found nested field in otherOption');
        // Recursively validate the nested fields
        isValid = _validateField(nestedField) && isValid;
      }
    }

    return isValid;
  }
//

  void _showBottomSheet(
      BuildContext context, List<dynamic> fields, String formId) {
    Map<String, dynamic> bottomSheetFormValues = {}; // To store form values

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Iterate through the fields and build form elements dynamically
                      ...fields.map<Widget>((field) {
                        switch (field['type']) {
                          case 'text':
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: field['labelText'],
                                  hintText: field['hintText'],
                                ),
                                onChanged: (value) {
                                  bottomSheetFormValues[field['id']] = value;
                                },
                              ),
                            );
                          case 'radio':
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(field['labelText'] ?? ''),
                                DynamicRadio(
                                  selectedOption:
                                      _formValues[field['id']] as String?,
                                  options: List<String>.from(field['options']),
                                  onChanged: (String? value) {
                                    setState(() {
                                      bottomSheetFormValues[field['id']] =
                                          value;
                                      _formValues[field['id']] = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (field['validation']['required'] ==
                                            true &&
                                        (value == null || value.isEmpty)) {
                                      return 'Please select an option';
                                    }
                                    return null;
                                  },
                                )
                                // ...List<Widget>.from(
                                //   field['options'].map<Widget>((option) {
                                //     return RadioListTile(
                                //       title: Text(option),
                                //       value: option,
                                //       groupValue:
                                //           bottomSheetFormValues[field['id']],
                                //       onChanged: (value) {
                                //         setState(() {
                                //           bottomSheetFormValues[field['id']] =
                                //               value;
                                //         });
                                //       },
                                //     );
                                //   }),
                                // ),
                              ],
                            );
                          case 'numeric':
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: field['labelText'],
                                  hintText: field['hintText'],
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  bottomSheetFormValues[field['id']] =
                                      int.tryParse(value) ?? 0;
                                },
                              ),
                            );
                          // Add more cases as needed for other field types
                          default:
                            return const SizedBox.shrink();
                        }
                      }),
                      ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('Form values: $bottomSheetFormValues');
                          }
                          // Handle form submission logic here
                          _submitFormData(bottomSheetFormValues, formId);

                          Navigator.pop(context); // Close the bottom sheet
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _submitFormData(Map<String, dynamic> formData, String formId) {
    if (kDebugMode) {
      print('Submitting form data: $formData');
    }

    // Ensure _formValues is initialized
    if (!_formValues.containsKey(formId)) {
      _formValues[formId] = [];
    }

    // Add new form data to the record list
    _formValues[formId]!.add(formData);

    // Trigger a state update if needed
    setState(() {});
  }

  void _showBottomSheet6(BuildContext context, List<dynamic> fields) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Iterate through the fields and build form elements dynamically
                  ...fields.map<Widget>((field) {
                    switch (field['type']) {
                      case 'text':
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: field['labelText'],
                              hintText: field['hintText'],
                            ),
                            onChanged: (value) {
                              // Handle text input changes here
                            },
                          ),
                        );
                      case 'radio':
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(field['labelText'] ?? ''),
                            DynamicRadio(
                              selectedOption:
                                  _formValues[field['id']] as String?,
                              options: List<String>.from(field['options']),
                              onChanged: (String? value) {
                                setState(() {
                                  _formValues[field['id']] = value;
                                });
                              },
                              validator: (value) {
                                if (field['validation']['required'] == true &&
                                    (value == null || value.isEmpty)) {
                                  return 'Please select an option';
                                }
                                return null;
                              },
                            )
                          ],
                        );
                      // Add more cases as needed for other field types
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
                  ElevatedButton(
                    onPressed: () {
                      // Handle form submission logic
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataTable(String fieldId) {
    if (_formValues[fieldId] == null || _formValues[fieldId].isEmpty) {
      return const Text('No records added yet.');
    }

    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(2), // Work Name
        1: FlexColumnWidth(2), // Annual Fund
        2: FlexColumnWidth(2), // Disbursal Duration
        3: FixedColumnWidth(96), // Action (fixed width for icon)
      },
      children: [
        TableRow(
          children: [
            _buildHeaderCell('Work Name'),
            _buildHeaderCell('Annual Fund'),
            _buildHeaderCell('Disbursal Duration'),
            _buildHeaderCell('Action'),
          ],
        ),
        ..._formValues[fieldId].asMap().entries.map<TableRow>((entry) {
          int index = entry.key;
          Map<String, dynamic> formData = entry.value;

          return TableRow(
            children: [
              _buildDataCell(formData['work_name']),
              _buildDataCell(formData['annual_fund'].toString()),
              _buildDataCell(formData['disbursal_duration']),
              _buildActionCell(fieldId, index),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String? text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 150), // Adjust width as needed
        child: Text(
          text ?? '',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis, // Wraps the text
        ),
      ),
    );
  }

  Widget _buildActionCell(String fieldId, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _deleteRecord(fieldId, index);
          },
        ),
      ),
    );
  }

  void _deleteRecord(String fieldId, int index) {
    setState(() {
      _formValues[fieldId].removeAt(index);

      // Update the state to reflect changes
      if (_formValues[fieldId].isEmpty) {
        _formValues.remove(fieldId);
      }
    });
  }

  Widget _buildDynamicField(Map<String, dynamic> otherOption) {
    switch (otherOption['type']) {
      case 'bottomsheet':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LabelText(label: otherOption['labelText']),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showBottomSheet(
                    context, otherOption['fields'], otherOption['id']);
              },
              child: const Text('Add Record'),
            ),
            const SizedBox(height: 16),
            _buildDataTable(otherOption['id']),
            const SizedBox(height: 20),
          ],
        );

      case 'photo_picker':
        return _buildPhotoPickerField(otherOption);

      case 'radio':
        return Column(
          children: [
            LabelText(
              label: otherOption['labelText'],
              astrick: true,
            ),
            DynamicRadio(
              selectedOption: _formValues[otherOption['id']],
              options: otherOption['options'],
              onChanged: (value) {
                setState(() {
                  _formValues[otherOption['id']] = value;

                  // Clear the "other_specify" value if "Other" is not selected
                  if (value != 'Other') {
                    // change for null [] _formValues[otherOption['otherOption']['id']] = null  ;
                    _formValues[otherOption['id']] = null;
                  }
                });
              },
              validator: (value) {
                if (otherOption['validation']['required'] == true &&
                    (value == null || value.isEmpty)) {
                  return 'Please select an option';
                }
                return null;
              },
              // focusNode: FocusNode(),
            ),
            const SizedBox(height: 20),

            // Conditionally show the "Specify Other" field
            if (_formValues[otherOption['id']] == 'Other')
              Column(
                children: [
                  LabelText(
                    label: 'Please specify',
                    astrick: true,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    textController: TextEditingController(
                      text: _formValues[otherOption['otherOption']['id']] ?? '',
                    ),
                    labelText: 'Specify your option',
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Please specify';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _formValues[otherOption['otherOption']['id']] = value;
                      });
                      return;
                    },
                  ),
                ],
              ),
          ],
        );

      case 'text':
        // Initialize the TextEditingController with the current value
        TextEditingController controller = TextEditingController(
          text: _formValues[otherOption['id']] ?? '',
        );

        return Column(
          children: [
            LabelText(
              label: otherOption['labelText'],
              astrick: true,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              textController: controller, // Use the initialized controller
              labelText: otherOption['hintText'],
              validator: (value) {
                if (otherOption['validation']?['required'] == true &&
                    value?.isEmpty == true) {
                  return 'This field is required';
                }
                return null;
              },
              onChanged: (value) {
                _formValues[otherOption['id']] = value;
                // });
                return;
              },
            ),
            const SizedBox(height: 20),
          ],
        );

      case 'section':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List<Widget>.from(
            otherOption['fields'].map<Widget>((field) {
              return _buildDynamicField(field);
            }),
          ),
        );

      case 'numeric':
        TextEditingController controller = TextEditingController(
          text: _formValues[otherOption['id']] ?? '',
        );

        return Column(
          children: [
            LabelText(
              label: otherOption['labelText'],
              astrick: true,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              textController: controller,
              labelText: otherOption['labelText'],
              hintText: otherOption['hintText'],
              textInputType: TextInputType.number,
              validator: (value) {
                if (otherOption['validation']?['required'] == true &&
                    value?.isEmpty == true) {
                  return 'This field is required';
                }
                return null;
              },
              onChanged: (value) {
                _formValues[otherOption['id']] = value;

                return;
              },
            ),
            const SizedBox(height: 20),
          ],
        );

      case 'radio_with_other':
        return Column(
          children: [
            LabelText(
              label: otherOption['labelText'],
              astrick: true,
            ),
            DynamicRadio(
              selectedOption: _formValues[otherOption['id']],
              options: otherOption['options'],
              onChanged: (value) {
                setState(() {
                  _formValues[otherOption['id']] = value;
                  if (value == 'Yes' && otherOption['otherOption'] != null) {
                    _formValues[otherOption['otherOption']['id']] = null;
                  }
                });
              },
              validator: (value) {
                if (otherOption['validation']['required'] == true &&
                    (value == null || value.isEmpty)) {
                  return 'Please select an option';
                }
                return null;
              },

              // focusNode: FocusNode(),
            ),
            if (_formValues[otherOption['id']] == 'Yes' &&
                otherOption['otherOption'] != null)
              _buildDynamicField(otherOption['otherOption']),
            const SizedBox(height: 20),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // Example grades list
  final List<String> grades = ['Grade 1', 'Grade 2', 'Grade 3'];

  // Map to hold teacher data for each grade
  final Map<String, TeacherData> teacherDataMap = {};
  Widget _buildTeacherFields() {
    final List<dynamic> selectedGrades = _formValues['grades_taught'] ?? [];

    return Column(
      children: [
        const SizedBox(height: 10),
        LabelText(
          label: 'Fill the enrolment record',
          astrick: true,
          textColor: AppColors.primary,
        ),
        const SizedBox(height: 10),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          border: TableBorder.all(),
          children: [
            const TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Grade',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Boys',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Girls',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            ...selectedGrades.map((grade) {
              teacherDataMap[grade] ??= TeacherData(grade: grade);

              TextEditingController maleController = TextEditingController(
                text: teacherDataMap[grade]?.maleTeachers.toString() ?? '',
              );
              TextEditingController femaleController = TextEditingController(
                text: teacherDataMap[grade]?.femaleTeachers.toString() ?? '',
              );

              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      grade,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextFormField(
                      labelText: '',
                      hintText: 'Enter number',
                      textInputType: TextInputType.number,
                      textController: maleController,
                      focusNode: FocusNode()
                        ..addListener(() {
                          if (maleController.text == '0' &&
                              maleController.text.isNotEmpty) {
                            maleController.clear();
                          }
                        }),
                      onChanged: (value) {
                        teacherDataMap[grade]?.maleTeachers =
                            int.tryParse(value) ?? 0;
                        updateStudentCount();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextFormField(
                      labelText: '',
                      hintText: 'Enter number',
                      textInputType: TextInputType.number,
                      textController: femaleController,
                      focusNode: FocusNode()
                        ..addListener(() {
                          if (femaleController.text == '0' &&
                              femaleController.text.isNotEmpty) {
                            femaleController.clear();
                          }
                        }),
                      onChanged: (value) {
                        teacherDataMap[grade]?.femaleTeachers =
                            int.tryParse(value) ?? 0;
                        updateStudentCount();
                      },
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePickerField(Map<String, dynamic> field) {
    TextEditingController dateController = TextEditingController(
      text: _formValues[field['name']],
    );

    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (selectedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
          setState(() {
            _formValues[field['name']] = formattedDate;
            dateController.text = formattedDate; // Update controller text
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: field['label'],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a date';
            }
            return null;
          },
          controller: dateController,
        ),
      ),
    );
  }

  Widget _buildPhotoPickerField(Map<String, dynamic> field) {
    if (field.isNotEmpty) {
      final photoPickerData = _photoPickerData.putIfAbsent(
        field['id'],
        () => PhotoPickerData(id: field['id'], photos: []),
      );

      // Check validation requirements
      final bool isRequired = field['validation']?['required'] ?? false;
      final int minPhotos = field['validation']?['minPhotos'] ?? 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field['labelText'] ?? 'Select Photos',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildPhotoSelection(photoPickerData, field),
          if (isRequired && photoPickerData.photos.length < minPhotos)
            const Text(
              'Please upload at least one photo.',
              style: TextStyle(color: Colors.red),
            ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildPhotoSelection(
      PhotoPickerData photoPickerData, Map<String, dynamic> field) {
    final maxPhotos = field['options']['maxPhotos'] ?? 5;

    return Column(
      children: [
        if (photoPickerData.photos.isEmpty)
          const Text('No photos selected')
        else
          _buildPhotoPreview(photoPickerData),
        Row(
          children: [
            if (field['options']['allowCamera'] ?? false)
              ElevatedButton(
                onPressed: () => _pickImageFromSource(
                    photoPickerData.id, ImageSource.camera, maxPhotos),
                child: const Text('Take Photo'),
              ),
            if (field['options']['allowGallery'] ?? false)
              ElevatedButton(
                onPressed: () => _pickImageFromSource(
                    photoPickerData.id, ImageSource.gallery, maxPhotos),
                child: const Text('Choose from Gallery'),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImageFromSource(
      String id, ImageSource source, int maxPhotos) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        final photoPickerData = _photoPickerData[id]!;
        if (photoPickerData.photos.length < maxPhotos) {
          photoPickerData.photos.add(File(pickedFile.path));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum number of photos reached.')),
          );
        }
      });
    }
  }

  Widget _buildPhotoPreview(PhotoPickerData photoPickerData) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photoPickerData.photos.length,
        itemBuilder: (context, index) {
          final photo = photoPickerData.photos[index];
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.file(
                  photo,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      photoPickerData.photos.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Method to build UDISE field and related dropdown
  // Method to build UDISE field and related autofill school name field
  Widget _buildUdiseField(Map<String, dynamic> field) {
    // Controller for UDISE code input
    String? udisefield;
    TextEditingController udiseController = TextEditingController(
      text: _formValues[field['id']] ?? '',
    );
    TextEditingController schoolNameController = TextEditingController(
      text: _schoolName ?? '',
    );

    setUdise(value) {
      setState(() {
        udisefield = value;
      });
    }

    // Controller for School Name input (auto-filled)
    setSchoolName(value) {
      setState(() {
        _schoolName = value.replaceAll(RegExp(r'^\[|\]$'), '');
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(
          label: field['labelText'],
          astrick: true,
        ),
        const SizedBox(height: 10),
        CustomTextFormField(
          textController: udiseController,
          labelText: field['labelText'],
          hintText: field['hintText'],
          textInputType: TextInputType.number,
          validator: (value) {
            if (field['validation']?['required'] == true &&
                value?.isEmpty == true) {
              return 'Please enter ${field['labelText']}';
            }
            return null;
          },
          onChanged: (value) async {
            if (value.isNotEmpty) {
              if (value.length == 11) {
                setUdise(value);
                _schoolName =
                    await context.read<FormCubit>().fetchSchool(value);
                setSchoolName(_schoolName);
              }
            }
          },
        ),
        const SizedBox(height: 20),
        LabelText(
          label: 'School Name',
          astrick: true,
        ),
        const SizedBox(height: 20),
        CustomTextFormField(
          textController: schoolNameController,
          labelText: "School Name",
          hintText: "Auto-filled School Name",
          readOnly: true, // Make the field uneditable
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Future<void> _uploadPhotosAndSubmitForm() async {
    try {
      int totalPhotos = _photoPickerData.values.fold(
        0,
        (sum, photoPickerData) => sum + photoPickerData.photos.length,
      );
      int uploadedPhotos = 0;
      double progress = 0.0;

      for (var entry in _photoPickerData.entries) {
        final photoPickerData = entry.value;
        final List<String> uploadedUrls = [];

        for (var photo in photoPickerData.photos) {
          final String? url = await _uploadPhoto(photo);
          if (url != null) {
            uploadedUrls.add(url);
          }

          uploadedPhotos++;
          progress = uploadedPhotos / totalPhotos;
          print('progress is change $progress');
        }

        _formValues[photoPickerData.id] = uploadedUrls;
      }
      context.read<FormCubit>().updateProgress(progress);

      String submitJsonData = jsonEncode(_formValues);
      context.read<FormCubit>().submitForm(submitJsonData, widget.id!);
    } catch (e) {
      context
          .read<FormCubit>()
          .handleError('Failed to upload photos and submit form');
    }
  }

  Future<String?> _uploadPhoto(File photo) async {
    const CircularProgressIndicator();

    // Define the URL for the photo upload API endpoint
    const String uploadUrl =
        'https://mis.17000ft.org/apis/fast_apis/imgupload.php'; // Replace with your actual URL

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Add the photo file to the request
      var photoStream = http.ByteStream(photo.openRead());
      var photoLength = await photo.length();
      var photoMultipartFile = http.MultipartFile(
        'file', // The name of the field in the form-data
        photoStream,
        photoLength,
        filename: photo.uri.pathSegments.last,
        //contentType: MediaType.parse(mime(photo.path) ?? 'application/octet-stream'),
      );

      request.files.add(photoMultipartFile);

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response body to get the URL
        var responseBody = await response.stream.bytesToString();
        // Assuming the server responds with a JSON object containing the URL
        // You may need to adjust this based on your server's response format
        var data = jsonDecode(responseBody);
        print('this is repsonse by phot $data');
        return data['url']; // The key should match the server's response
      } else {
        // Handle error response
        print('Failed to upload photo. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred while uploading photo: $e');
      return null;
    }
  }

  void updateStudentCount() {
    _formValues['student_count'] = teacherDataMap.entries.map((entry) {
      return entry.value.toMap();
    }).toList();
  }
}

class TeacherData {
  final String grade;
  int maleTeachers;
  int femaleTeachers;

  TeacherData({
    required this.grade,
    this.maleTeachers = 0,
    this.femaleTeachers = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'grade': grade,
      'boys': maleTeachers,
      'girls': femaleTeachers,
    };
  }
}

class YearPickerDialog extends StatelessWidget {
  final int initialYear;
  final int startYear;
  final int endYear;

  const YearPickerDialog({
    super.key,
    required this.initialYear,
    required this.startYear,
    required this.endYear,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Year'),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: YearPicker(
          selectedDate: DateTime(initialYear),
          firstDate: DateTime(startYear),
          lastDate: DateTime(endYear),
          onChanged: (DateTime dateTime) {
            Navigator.pop(context, dateTime.year);
          },
        ),
      ),
    );
  }
}

//
