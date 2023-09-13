part of 'main.dart';

const vini = EvidenceTopicPublisher(
  id: "1",
  name: "Vini Rodrigues",
  profilePictureUrl: "https://pbs.twimg.com/profile_images/1584303098687885312/SljBjw26_400x400.jpg",
);

const prioli = EvidenceTopicPublisher(
  id: "2",
  name: "Gabriela Prioli",
  profilePictureUrl: "https://pbs.twimg.com/profile_images/1262904392698732544/MRyW36Kp_400x400.jpg",
);

const lipsum = EvidenceTopicPublisher(
  id: "2",
  name: "Lipsum",
  profilePictureUrl:
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVvZ2xzLACaO5kX9Y4pk4PSV5YtQyB0FGzXbVymuNSQjZLyoGr9jL0Xgb5AO0oGZSdSzc&usqp=CAU",
);

const lipsumLipsum2 = EvidenceTopic(
  declaration:
      "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",
  publisher: lipsum,
  arguments: [],
);

const prioliAboutUnequality = EvidenceTopic(
  declaration: "O dinheiro não fará diferença pra quem está dando, mas fará diferença para quem está recebendo.",
  publisher: prioli,
  arguments: [
    EvidenceArgument(topic: lipsumLipsum2, type: EvidenceArgumentType.inFavor),
  ],
);

const lipsumAboutChildWork = EvidenceTopic(
  declaration: "Esta prática incentiva o trabalho infantil, portanto, deve ser erradicada.",
  publisher: lipsum,
  arguments: [],
);

const lipsumLipsum1 = EvidenceTopic(
  declaration:
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
  publisher: lipsum,
  arguments: [],
);

const viniAboutChildren = EvidenceTopic(
  declaration: "Não se deve dar dinheiro para crianças na rua.",
  publisher: vini,
  arguments: [
    EvidenceArgument(topic: prioliAboutUnequality, type: EvidenceArgumentType.against),
    EvidenceArgument(topic: lipsumAboutChildWork, type: EvidenceArgumentType.inFavor),
    EvidenceArgument(topic: lipsumLipsum2, type: EvidenceArgumentType.against),
    EvidenceArgument(topic: lipsumLipsum1, type: EvidenceArgumentType.against),
  ],
);

const topics = [
  viniAboutChildren,
  prioliAboutUnequality,
  lipsumLipsum2,
];
