import 'package:flutter/material.dart';

class SymptomsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptoms of Hand, Foot, and Mouth Disease'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Symptoms'),
            _symptomItem(
              'Fever and flu-like symptoms',
              'Children often get a fever and other flu-like symptoms 3 to 5 days after they catch the virus. These can include:',
              [
                'Fever',
                'Eating or drinking less',
                'Sore throat',
                'Feeling unwell',
              ],
            ),
            _symptomItem(
              'Mouth sores',
              'Your child can get painful mouth sores. These sores usually start as small red spots, often on the tongue and insides of the mouth, that blister and can become painful.',
              [
                'Not eating or drinking',
                'Drooling more than usual',
                'Only wanting to drink cold fluids',
              ],
            ),
            _symptomItem(
              'Skin rash',
              'Your child can get a skin rash on the palms of the hands and soles of the feet. It can also show up on the buttocks, legs, and arms.',
              [
                'The rash usually is not itchy and looks like flat or slightly raised red spots, sometimes with blisters that have an area of redness at their base.',
                'Fluid in the blister can contain the virus that causes HFMD.',
                'Keep blisters clean and avoid touching them.',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _symptomItem(String title, String description, List<String> symptoms) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: symptoms
                .map((symptom) => _bulletPoint(symptom))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(
              Icons.brightness_1,
              size: 8,
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
