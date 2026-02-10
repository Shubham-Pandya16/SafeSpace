enum ScaleType { phq9, gad7, dassDepression, dassAnxiety, dassStress }

class Question {
  final String id;
  final String text;
  final List<String> options;
  final ScaleType scale;

  const Question({
    required this.id,
    required this.text,
    required this.options,
    required this.scale,
  });
}

const List<String> standardOptions = [
  "Not at all",
  "Several days",
  "More than half the days",
  "Nearly every day",
];

const List<Question> mentalHealthQuestionnaire = [
  //  PHQ-9 (Depression) - 7 questions
  Question(
    id: "phq1",
    text: "Little interest or pleasure in doing things",
    options: standardOptions,
    scale: ScaleType.phq9,
  ),
  Question(
    id: "phq2",
    text: "Feeling down, depressed, or hopeless",
    options: standardOptions,
    scale: ScaleType.phq9,
  ),
  Question(
    id: "phq3",
    text: "Trouble falling or staying asleep, or sleeping too much",
    options: standardOptions,
    scale: ScaleType.phq9,
  ),
  Question(
    id: "phq4",
    text: "Feeling tired or having little energy",
    options: standardOptions,
    scale: ScaleType.phq9,
  ),
  Question(
    id: "phq6",
    text:
        "Feeling bad about yourself — or that you are a failure or have let yourself or your family down",
    options: standardOptions,
    scale: ScaleType.phq9,
  ),
  Question(
    id: "phq7",
    text:
        "Trouble concentrating on things, such as reading or watching television",
    options: standardOptions,
    scale: ScaleType.phq9,
  ),
  Question(
    id: "phq9",
    text: "Thoughts that you would be better off dead, or of hurting yourself",
    options: standardOptions,
    scale: ScaleType.phq9,
  ),

  //  GAD-7 (Anxiety) - 6 questions
  Question(
    id: "gad1",
    text: "Feeling nervous, anxious, or on edge",
    options: standardOptions,
    scale: ScaleType.gad7,
  ),
  Question(
    id: "gad2",
    text: "Not being able to stop or control worrying",
    options: standardOptions,
    scale: ScaleType.gad7,
  ),
  Question(
    id: "gad3",
    text: "Worrying too much about different things",
    options: standardOptions,
    scale: ScaleType.gad7,
  ),
  Question(
    id: "gad4",
    text: "Trouble relaxing",
    options: standardOptions,
    scale: ScaleType.gad7,
  ),
  Question(
    id: "gad6",
    text: "Becoming easily annoyed or irritable",
    options: standardOptions,
    scale: ScaleType.gad7,
  ),
  Question(
    id: "gad7",
    text: "Feeling afraid as if something awful might happen",
    options: standardOptions,
    scale: ScaleType.gad7,
  ),

  //  DASS-21 (Depression, Anxiety, Stress) - 7 questions
  Question(
    id: "dassD1",
    text: "I couldn't seem to experience any positive feeling at all",
    options: standardOptions,
    scale: ScaleType.dassDepression,
  ),
  Question(
    id: "dassD4",
    text: "I felt down-hearted and blue",
    options: standardOptions,
    scale: ScaleType.dassDepression,
  ),
  Question(
    id: "dassA1",
    text: "I was aware of dryness of my mouth",
    options: standardOptions,
    scale: ScaleType.dassAnxiety,
  ),
  Question(
    id: "dassA5",
    text: "I felt close to panic",
    options: standardOptions,
    scale: ScaleType.dassAnxiety,
  ),
  Question(
    id: "dassS1",
    text: "I found it hard to wind down",
    options: standardOptions,
    scale: ScaleType.dassStress,
  ),
  Question(
    id: "dassS3",
    text: "I felt that I was using a lot of nervous energy",
    options: standardOptions,
    scale: ScaleType.dassStress,
  ),
  Question(
    id: "dassS5",
    text: "I found it difficult to relax",
    options: standardOptions,
    scale: ScaleType.dassStress,
  ),
];
