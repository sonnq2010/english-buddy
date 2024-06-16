import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/home_screen/widgets/control_buttons/dropdown_button.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 160,
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
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(
                width: 160,
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
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(
                width: 160,
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
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(
                width: 160,
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
        ],
      ),
    );
  }
}
