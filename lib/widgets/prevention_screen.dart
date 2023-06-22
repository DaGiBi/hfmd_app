import 'package:flutter/material.dart';
class PreventionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prevent Hand, Foot, and Mouth Disease'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Wash your hands',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Text(
              'Wash your hands often with soap and water for at least 20 seconds. If soap and water are not available, use an alcohol-based hand sanitizer.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              'Always wash your hands:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            Text(
              '- After changing diapers.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- After using the toilet.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- After blowing your nose, coughing, or sneezing.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Before and after caring for someone who is sick.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Help children wash their hands. Teach them how to wash their hands and make sure they wash them often. Help them keep blisters clean and avoid touching them.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              'Avoid close contact with people who are sick',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Text(
              'Avoid touching someone who has HFMD, such as hugging or kissing them.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              'Can my child return to school if they are sick?',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Text(
              'Because HFMD is normally mild, children can continue to go to child care and schools as long as they:',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 8),
            Text(
              '- Have no fever.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Have no uncontrolled drooling with mouth sores.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Feel well enough to participate in classroom activities.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              'Talk with your child’s healthcare provider if you are still not sure when it is okay for them to return. In some cases, the local health department may require children with HFMD to stay home to control an outbreak.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              'Avoid touching your eyes, nose, and mouth',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Text(
              'You can get infected with HFMD if you have the virus on your hands and then touch your eyes, nose, or mouth. To reduce your chance of getting sick, don’t touch your eyes, nose, and mouth with unwashed hands.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              'Clean and disinfect',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Text(
              'Clean and disinfect frequently touched surfaces and shared items, such as toys and doorknobs.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}

