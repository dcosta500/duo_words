// Upload Chapter
import 'package:cloud_firestore/cloud_firestore.dart';

import '../word/language.dart';
import '../word/word.dart';

// Get language
Future<Map<String, List<Word>>> getLanguageWords(String language) async {
  List<Chapter>? chs = chaptersOfLanguage[language];
  Map<String, List<Word>> wordMap = {};

  for (var ch in chs!) {
    final collectionRef = FirebaseFirestore.instance
        .collection('words')
        .doc(language)
        .collection(ch.name);

    QuerySnapshot querySnapshot = await collectionRef.get();
    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Access data from each document
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Word w = Word.fromJson(data);

        wordMap.putIfAbsent(ch.name, () {
          List<Word> w = [];
          return w;
        });
        wordMap[ch.name]!.add(w);
      }
    } else {
      print('No documents found in the collection.');
    }
  }
  return wordMap;
}

Future<List<String>> getLanguageCourses() async {
  final collectionRef = FirebaseFirestore.instance.collection('languages');

  List<String> languages = [];
  try {
    QuerySnapshot querySnapshot = await collectionRef.get();
    if (querySnapshot.docs.isNotEmpty) {
      languages.addAll(querySnapshot.docs.map((doc) => doc.id));
    } else {
      print('No languages found in the collection');
    }
  } catch (e) {
    print('Error fetching documents: $e');
  }

  return languages;
}

Future<List<String>> getChapters() async {
  final collectionRef = FirebaseFirestore.instance.collection('chapters');

  List<String> chapters = [];
  try {
    QuerySnapshot querySnapshot = await collectionRef.get();
    if (querySnapshot.docs.isNotEmpty) {
      chapters.addAll(querySnapshot.docs.map((doc) => doc.id));
    } else {
      print('No chapters found in the collection');
    }
  } catch (e) {
    print('Error fetching documents: $e');
  }

  return chapters;
}
