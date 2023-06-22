import 'package:flutter/material.dart';

class SpreadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How Hand, Foot, and Mouth Disease Spreads'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Hand, foot, and mouth disease (HFMD) spreads easily through:',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              '- Person-to-person contact.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Droplets made when a person who is sick with HFMD sneezes, coughs, or talks.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Contact with contaminated surfaces and objects.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              'Is hand, foot, and mouth disease contagious?',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Text(
              'Yes. HFMD is caused by viruses. A person infected with one of these viruses is contagious, which means that they can pass the virus to other people.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 8),
            Text(
              'If someone is sick with HFMD, the virus can be found in their:',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 8),
            Text(
              '- Nose and throat secretions, such as saliva, drool, or nasal mucus',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Fluid from blisters',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Feces (poop)',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              'How do you get hand, foot, and mouth disease?',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Text(
              'You can get hand, foot, and mouth disease through the following ways:',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 8),
            Text(
              '- Contact with droplets that contain the virus made when a person sick with HFMD coughs, sneezes, or talks.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Touching an infected person or making other close contact with them, such as kissing, hugging, or sharing cups or eating utensils.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Touching an infected person’s poop, such as changing diapers, and then touching your eyes, nose, or mouth.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Touching objects and surfaces that have the virus on them, like doorknobs or toys, and then touching your eyes, nose, or mouth.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Although rare, you can also get the viruses by swallowing recreational water, like in swimming pools. This happens if the water has been contaminated with the virus from a person who is sick with HFMD.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}