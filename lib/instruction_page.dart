import 'package:flutter/material.dart';
import 'base_page.dart'; // Import BasePage

class InstructionPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [

    {
      "question": "What are the common symptoms of heart failure?",
      "answer": "Common symptoms include shortness of breath, fatigue, swelling in the legs or abdomen, persistent cough, rapid or irregular heartbeat, and sudden weight gain."
    },
    {
      "question": "What are the main types of heart failure?",
      "answer": "The main types are heart failure with reduced ejection fraction (HFrEF) and heart failure with preserved ejection fraction (HFpEF)."
    },
    {
      "question": "What causes heart failure?",
      "answer": "Causes include coronary artery disease, high blood pressure, heart valve problems, cardiomyopathy, and previous heart attacks."
    },
    {
      "question": "Why is monitoring weight important in heart failure?",
      "answer": "Daily weight monitoring can help detect fluid retention early, which may indicate worsening heart failure and the need for treatment adjustment."
    },
    {
      "question": "How can I manage swelling caused by heart failure?",
      "answer": "Managing swelling involves reducing sodium intake, using diuretics as prescribed, and elevating the legs to reduce fluid accumulation."
    },
    {
      "question": "Are there any specific dietary restrictions for heart failure patients?",
      "answer": "Patients are often advised to follow a low-sodium diet to help manage fluid retention and high blood pressure. Limiting fluid intake might also be necessary for some individuals."
    },
    {
      "question": "What causes shortness of breath?",
      "answer": "The blood backup in the pulmonary veins occurs because the heart cannot keep up with the blood supply, causing fluid to leak into the lungs."
    },
    {
      "question": "What causes persistent coughing or wheezing?",
      "answer": "Persistent coughing produces white or pink blood-tinged mucus, which occurs due to blood backup in the pulmonary veins, leading to fluid buildup in the lungs."
    },
    {
      "question": "What causes excess fluid in the body tissue (edema)?",
      "answer": "Swelling of feet, ankles, legs, fingers, abdomen, and other organs occurs because the heart isn't working properly, causing blood to back up into vessels and tissues, resulting in swelling."
    },
    {
      "question": "What causes tiredness or fatigue?",
      "answer": "The heart can't pump enough blood to meet the body's needs. Blood is diverted from less vital organs, like the muscles in the limbs, to the heart and brain."
    },
    {
      "question": "What causes lack of appetite or nausea?",
      "answer": "The digestive system receives less blood, leading to problems with digestion, which can cause a feeling of fullness or nausea."
    },
    {
      "question": "What causes confusion or impaired thinking?",
      "answer": "Reduced blood flow to the brain, along with changing levels of substances like sodium, can lead to confusion, memory loss, and disorientation."
    },
    {
      "question": "What causes increased heart rate?",
      "answer": "The heart compensates for its reduced pumping power by beating faster (tachycardia) to maintain blood flow, which may cause palpitations or irregular heartbeats."
    },
    {
      "question": "What causes weight changes?",
      "answer": "Reduced blood flow to the stomach can make it harder to absorb nutrients, causing weight loss, while fluid retention may lead to weight gain."
    },
    {
      "question": "What causes chest pain?",
      "answer": "Chest pain (angina) occurs when the heart muscle doesn't get enough oxygen-rich blood, causing pressure or discomfort that can also radiate to the shoulders, arms, neck, jaw, or back."
    },
    {
      "question": "What causes an increase in blood pressure?",
      "answer": "As the heart weakens, it can't pump effectively, leading to hormone release that narrows blood vessels and causes fluid retention, raising blood pressure and straining the heart further."
    }

  ];

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Instruction',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(
                faqs[index]['question']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    faqs[index]['answer']!,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
              tilePadding: EdgeInsets.symmetric(vertical: 8.0),
              collapsedIconColor: Colors.white,
              iconColor: Colors.white,
              backgroundColor: Colors.grey[800]?.withOpacity(0.5),
              collapsedBackgroundColor: Colors.grey[800]?.withOpacity(0.5),
            );
          },
        ),
      ),
    );
  }
}


