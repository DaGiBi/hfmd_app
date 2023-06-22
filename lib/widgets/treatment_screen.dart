import 'package:flutter/material.dart';

class TreatmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Treat Hand, Foot, and Mouth Disease'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Most people with hand, foot, and mouth disease (HFMD) get better on their own in 7 to 10 days. There is no specific medical treatment for HFMD.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              'Treat symptoms and prevent dehydration',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Text(
              'You can take steps to relieve symptoms and prevent dehydration while you or your child are sick.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 8),
            Text(
              '- Take over-the-counter medications to relieve fever and pain caused by mouth sores. These medications can include acetaminophen or ibuprofen. Never give aspirin to children.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Drink enough liquids. Mouth sores can make it painful to swallow, so your child may not want to drink much. Make sure they drink enough to stay hydrated.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              'When to see a healthcare provider',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Text(
              'You should see a healthcare provider if:',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 8),
            Text(
              '- Your child is not able to drink normally and you’re worried they might be getting dehydrated.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Your child’s fever lasts longer than 3 days.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Your child has a weakened immune system (body’s ability to fight germs and sickness).',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Symptoms are severe.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Your child is very young, especially younger than 6 months.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
