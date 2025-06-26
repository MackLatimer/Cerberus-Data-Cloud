import 'package:flutter/material.dart';

class JoinListSection extends StatelessWidget {
  const JoinListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'JOIN OUR EMAIL AND TEXT LIST',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16.0),
        const TextField(
          decoration: InputDecoration(
            labelText: 'First name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Last name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          '*By including your email, you agree to be a part of our email list.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16.0),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Phone',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          '*By including your phone number, you agree to be a part of our text list.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            // TODO: Implement submit functionality
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
