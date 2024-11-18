import 'package:googleapis_auth/auth_io.dart';

Map _securityJson = {
  "type": "service_account",
  "project_id": "duo-words-ca0ac",
  "private_key_id": "f854c008043cf5453fe51a3b071e6b48641cad45",
  "private_key":
      "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDJaPQSLyJQCeZE\nn+T77JTqfccdAfYlbs9u7Zv2nGL+AX5DfxbPebZe44jYobi51DuMkkDMmdpCdCSp\ncldpbh7Jk0t3ipV3RBpqS90l5WzUjKmlnWXZTUOg02GcWYYedfOgI3UCXqqbiEyI\nzbF5SO1Y1MmWyr5yx8Gw75TEuvIvfx9a5ievr12UWeqvrR5mWnh/CFHwFgY0Tve7\noVqrRWXoVBOEAQwR798JuKOz9Mz+R8a6uPbpUXVKbcgRdIu5bBGyyOcpK6xKdEfP\nRK7/M8s13vOP5KXpqi7Pr0Ag9C6cRk70gHyAq5JbDj2VnHGPF+7PHl7jqOHyX/TL\nC8P7ankfAgMBAAECggEABOuUctFF9FCZmHmTfXgFF0llUNcYbUest5gEZFzjqjLd\nI8b6Bq2BgAXs9OXWfmup3MBB5v2nMFJoBt+tNP0ksWXwxQXUquo1/vzFdUSKiRK6\nnjofH9TcXxRq4Qfq19mnzvSuyhUH8+67d+gWetEGQ1JHbnCbgHBS0gC4UKoEepaE\nSomnDwu6JIbsExT3jLQ2sNzahQ9eybgEQVgFSE8jYV46Ihky0c31PWr5K8ggmtBf\nRLXCEPsCynGSPplGL+jsQkBYwQRznqgArkZDKHDYw7kBqN6/a3A/cTyiPtQmovy4\nH6US+K+qtkzaiOCxXnJZx4wSqNeHTDnLC8mFezG6WQKBgQD20hR4EsFNwWMslKX4\nXrARIen4EuWtWVLkHMtlF3gou/o23dIV0PjPF1sJZ+HjmnR2Cd/MdvsKzO3V+KZu\ntoMhADjePuUsHBCpflcRGTucnEox/HfgrKafsKymjZXJF0voAGbtDHe6MF+CTYe9\nrJH+qlVKtod26zkub7hwegS2iwKBgQDQ5oeOj9o0PZtX7cUCQ9NvWLbVo/ZT4l8P\nFerOWV71IyO8TBtOrZKjUIM+tq3z8+YrlLOgA9WStl3G5Y3eJCbLabYXFojq0TpP\ncOrUT9KSmzd5KS+kbdYqoFttXonQoWIo2qTlCe1DyOSk8EJlCCUAoTYY/KaXremm\nSK+0nDouPQKBgA8zONd8MDNdqYHhVadKDYXAlOwWHdbjHVu2+j+rhlbb3LjsSDfX\nurrmMVEO+LZPmMR8LzAkU6mCnVMEERvYWZL6tIXbUbm5sLz/btU6vJUUeu1BIxDP\nESPceYV4SrUrnh0XiT8n+WeZ+wfHRojDy+nnC4GiZA1Kxya48p7apNepAoGARP5u\ndQJD0g8q2D6aW6YlFdhaAnN1rrzMIoJdm6tetl3VtqH4PuMK1E+KGVNiXnkGYwxo\nyweZKSx8Cm3UjjKocXRHhJaXv948gPJNTLPUW0FSb/zPVGJGYqu1poibwcEbV1zn\nKxI9P68A/QyxEQdAmVWlNVl0eBIjYh0NkvwqJw0CgYAFOl3FsT++0P/lZsKNbznu\nDF14vT5h7oJlAe4rVEXzYhn7SisaPbZ7sn5pDjTyMou19AykeOu/LoKyZUp+1dST\nzRl90a5x9wFjYZ2Gkh8VMw0FWfKl73gAUknrs8gvqP4UEA+ILKQcf14ZrNQqJZz/\nnqnDDePrCgblj+wMA7Q4KQ==\n-----END PRIVATE KEY-----\n",
  "client_email":
      "firebase-adminsdk-x8uge@duo-words-ca0ac.iam.gserviceaccount.com",
  "client_id": "106819741826794524156",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url":
      "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-x8uge%40duo-words-ca0ac.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};

Future<List<String>> get_auth() async {
  // Load service account credentials from JSON file
  final serviceAccount = _securityJson;
  final clientEmail = serviceAccount['client_email'];
  final privateKey = serviceAccount['private_key'];

  // Create a service account auth client
  final client = await clientViaServiceAccount(
    ServiceAccountCredentials(clientEmail, ClientId('', ''), privateKey),
    ['https://www.googleapis.com/auth/datastore'], // Firestore scope
  );

  // Get the access token
  String accessToken = client.credentials.accessToken.data;
  String projectId = serviceAccount['project_id'] as String;
  print('Access token obtained.');

  return [accessToken, projectId];
}
