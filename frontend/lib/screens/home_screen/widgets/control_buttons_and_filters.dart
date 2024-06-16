import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons/control_buttons.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons/dropdown_button.dart';

class ControllButtonsAndFilters extends StatelessWidget {
  const ControllButtonsAndFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: FittedBox(child: ControlButtons()),
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildFilters()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        FittedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text('You are:'),
                    ),
                    const SizedBox(width: 8),
                    CustomizeDropdownButton<Gender>(
                      values: const {
                        Gender.all: '',
                        Gender.male: 'Male',
                        Gender.female: 'Female',
                      },
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FittedBox(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text('You are looking for:'),
                    ),
                    const SizedBox(width: 8),
                    CustomizeDropdownButton<Gender>(
                      initialValue: Gender.all,
                      values: const {
                        Gender.all: 'All gender',
                        Gender.male: 'Male',
                        Gender.female: 'Female',
                      },
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //////
        const SizedBox(width: 32),
        //////

        FittedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text('Your English level:'),
                    ),
                    const SizedBox(width: 8),
                    CustomizeDropdownButton<EnglishLevel>(
                      values: const {
                        EnglishLevel.all: '',
                        EnglishLevel.a1: 'A1',
                        EnglishLevel.a2: 'A2',
                        EnglishLevel.b1: 'B1',
                        EnglishLevel.b2: 'B2',
                        EnglishLevel.c1: 'C1',
                        EnglishLevel.c2: 'C2',
                      },
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FittedBox(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text('You want to match with:'),
                    ),
                    const SizedBox(width: 8),
                    CustomizeDropdownButton<EnglishLevel>(
                      initialValue: EnglishLevel.all,
                      values: const {
                        EnglishLevel.all: 'All level',
                        EnglishLevel.a1: 'A1',
                        EnglishLevel.a2: 'A2',
                        EnglishLevel.b1: 'B1',
                        EnglishLevel.b2: 'B2',
                        EnglishLevel.c1: 'C1',
                        EnglishLevel.c2: 'C2',
                      },
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
    // return Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Row(
    //       children: [
    //         const Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text('You are:'),
    //             Text('You are looking for:'),
    //           ],
    //         ),
    //         const SizedBox(width: 16),
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             CustomizeDropdownButton<Gender>(
    //               values: const {
    //                 Gender.all: '',
    //                 Gender.male: 'Male',
    //                 Gender.female: 'Female',
    //               },
    //               onChanged: (value) {},
    //             ),
    //             const SizedBox(height: 8),
    //             CustomizeDropdownButton<Gender>(
    //               initialValue: Gender.all,
    //               values: const {
    //                 Gender.all: 'All gender',
    //                 Gender.male: 'Male',
    //                 Gender.female: 'Female',
    //               },
    //               onChanged: (value) {},
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //     // Row(
    //     //   children: [
    //     //     const Text('You are:'),
    //     //     const SizedBox(width: 8),
    //     //     CustomizeDropdownButton<Gender>(
    //     //       values: const {
    //     //         Gender.all: '',
    //     //         Gender.male: 'Male',
    //     //         Gender.female: 'Female',
    //     //       },
    //     //       onChanged: (value) {},
    //     //     ),
    //     //     ////////
    //     //     const SizedBox(width: 32),
    //     //     ////////
    //     //     const Text('You are looking for:'),
    //     //     const SizedBox(width: 8),
    //     //     CustomizeDropdownButton<Gender>(
    //     //       initialValue: Gender.all,
    //     //       values: const {
    //     //         Gender.all: 'All gender',
    //     //         Gender.male: 'Male',
    //     //         Gender.female: 'Female',
    //     //       },
    //     //       onChanged: (value) {},
    //     //     ),
    //     //   ],
    //     // ),
    //     // const SizedBox(height: 16),
    //     // Row(
    //     //   children: [
    //     //     const Text('Your English level:'),
    //     //     const SizedBox(width: 8),
    //     //     CustomizeDropdownButton<EnglishLevel>(
    //     //       values: const {
    //     //         EnglishLevel.all: '',
    //     //         EnglishLevel.a1: 'A1',
    //     //         EnglishLevel.a2: 'A2',
    //     //         EnglishLevel.b1: 'B1',
    //     //         EnglishLevel.b2: 'B2',
    //     //         EnglishLevel.c1: 'C1',
    //     //         EnglishLevel.c2: 'C2',
    //     //       },
    //     //       onChanged: (value) {},
    //     //     ),
    //     //     ////////
    //     //     const SizedBox(width: 32),
    //     //     ////////
    //     //     const Text('You want to match with:'),
    //     //     const SizedBox(width: 8),
    //     //     CustomizeDropdownButton<EnglishLevel>(
    //     //       initialValue: EnglishLevel.all,
    //     //       values: const {
    //     //         EnglishLevel.all: 'All level',
    //     //         EnglishLevel.a1: 'A1',
    //     //         EnglishLevel.a2: 'A2',
    //     //         EnglishLevel.b1: 'B1',
    //     //         EnglishLevel.b2: 'B2',
    //     //         EnglishLevel.c1: 'C1',
    //     //         EnglishLevel.c2: 'C2',
    //     //       },
    //     //       onChanged: (value) {},
    //     //     ),
    //     //   ],
    //     // ),
    //   ],
    // );
  }
}
