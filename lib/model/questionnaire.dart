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
  //  PHQ-9 (Depression)
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
    id: "phq5",
    text: "Poor appetite or overeating",
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
    id: "phq8",
    text:
        "Moving or speaking so slowly that others could have noticed, or being unusually restless",
    options: standardOptions,
    scale: ScaleType.phq9,
  ),
  Question(
    id: "phq9",
    text: "Thoughts that you would be better off dead, or of hurting yourself",
    options: standardOptions,
    scale: ScaleType.phq9,
  ),

  //  GAD-7 (Anxiety)
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
    id: "gad5",
    text: "Being so restless that it is hard to sit still",
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

  //  DASS-21 (Depression)
  Question(
    id: "dassD1",
    text: "I couldn’t seem to experience any positive feeling at all",
    options: standardOptions,
    scale: ScaleType.dassDepression,
  ),
  Question(
    id: "dassD2",
    text: "I found it difficult to work up the initiative to do things",
    options: standardOptions,
    scale: ScaleType.dassDepression,
  ),
  Question(
    id: "dassD3",
    text: "I felt that I had nothing to look forward to",
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
    id: "dassD5",
    text: "I was unable to become enthusiastic about anything",
    options: standardOptions,
    scale: ScaleType.dassDepression,
  ),
  Question(
    id: "dassD6",
    text: "I felt I wasn’t worth much as a person",
    options: standardOptions,
    scale: ScaleType.dassDepression,
  ),
  Question(
    id: "dassD7",
    text: "I felt that life was meaningless",
    options: standardOptions,
    scale: ScaleType.dassDepression,
  ),

  //  DASS-21 (Anxiety)
  Question(
    id: "dassA1",
    text: "I was aware of dryness of my mouth",
    options: standardOptions,
    scale: ScaleType.dassAnxiety,
  ),
  Question(
    id: "dassA2",
    text: "I experienced breathing difficulty",
    options: standardOptions,
    scale: ScaleType.dassAnxiety,
  ),
  Question(
    id: "dassA3",
    text: "I experienced trembling",
    options: standardOptions,
    scale: ScaleType.dassAnxiety,
  ),
  Question(
    id: "dassA4",
    text: "I was worried about situations in which I might panic",
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
    id: "dassA6",
    text: "I was aware of the action of my heart",
    options: standardOptions,
    scale: ScaleType.dassAnxiety,
  ),
  Question(
    id: "dassA7",
    text: "I felt scared without any good reason",
    options: standardOptions,
    scale: ScaleType.dassAnxiety,
  ),

  //  DASS-21 (Stress)
  Question(
    id: "dassS1",
    text: "I found it hard to wind down",
    options: standardOptions,
    scale: ScaleType.dassStress,
  ),
  Question(
    id: "dassS2",
    text: "I tended to over-react to situations",
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
    id: "dassS4",
    text: "I found myself getting agitated",
    options: standardOptions,
    scale: ScaleType.dassStress,
  ),
  Question(
    id: "dassS5",
    text: "I found it difficult to relax",
    options: standardOptions,
    scale: ScaleType.dassStress,
  ),
  Question(
    id: "dassS6",
    text: "I was intolerant of anything that kept me from getting on",
    options: standardOptions,
    scale: ScaleType.dassStress,
  ),
  Question(
    id: "dassS7",
    text: "I felt that I was rather touchy",
    options: standardOptions,
    scale: ScaleType.dassStress,
  ),
];
