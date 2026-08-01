import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/providers.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../features/authentication/presentation/providers/auth_provider.dart'
    show storageServiceProvider;

const _kHistoryKey = 'translator_history_v1';
const _kFavoritesKey = 'translator_favorites_v1';

const _languages = <String>[
  'Auto',
  'Arabic',
  'English',
  'French',
  'German',
  'Spanish',
  'Italian',
  'Turkish',
];

const _langCode = {
  'Arabic': 'ar',
  'English': 'en',
  'French': 'fr',
  'German': 'de',
  'Spanish': 'es',
  'Italian': 'it',
  'Turkish': 'tr',
};

// ─── Comprehensive Travel Dictionary ─────────────────────────────────────

const _wordDict = {
  'hello': {'ar': 'مرحبا', 'fr': 'Bonjour', 'de': 'Hallo', 'es': 'Hola', 'it': 'Ciao', 'tr': 'Merhaba'},
  'hi': {'ar': 'مرحبا', 'fr': 'Salut', 'de': 'Hi', 'es': 'Hola', 'it': 'Ciao', 'tr': 'Merhaba'},
  'goodbye': {'ar': 'مع السلامة', 'fr': 'Au revoir', 'de': 'Auf Wiedersehen', 'es': 'Adiós', 'it': 'Arrivederci', 'tr': 'Hoşça kal'},
  'thank you': {'ar': 'شكرا', 'fr': 'Merci', 'de': 'Danke', 'es': 'Gracias', 'it': 'Grazie', 'tr': 'Teşekkürler'},
  'thanks': {'ar': 'شكرا', 'fr': 'Merci', 'de': 'Danke', 'es': 'Gracias', 'it': 'Grazie', 'tr': 'Teşekkürler'},
  'yes': {'ar': 'نعم', 'fr': 'Oui', 'de': 'Ja', 'es': 'Sí', 'it': 'Sì', 'tr': 'Evet'},
  'no': {'ar': 'لا', 'fr': 'Non', 'de': 'Nein', 'es': 'No', 'it': 'No', 'tr': 'Hayır'},
  'please': {'ar': 'من فضلك', 'fr': 'S\'il vous plaît', 'de': 'Bitte', 'es': 'Por favor', 'it': 'Per favore', 'tr': 'Lütfen'},
  'sorry': {'ar': 'آسف', 'fr': 'Désolé', 'de': 'Entschuldigung', 'es': 'Lo siento', 'it': 'Mi dispiace', 'tr': 'Üzgünüm'},
  'excuse me': {'ar': 'عذرا', 'fr': 'Excusez-moi', 'de': 'Entschuldigen Sie', 'es': 'Disculpe', 'it': 'Mi scusi', 'tr': 'Affedersiniz'},
  'help': {'ar': 'مساعدة', 'fr': 'Aide', 'de': 'Hilfe', 'es': 'Ayuda', 'it': 'Aiuto', 'tr': 'Yardım'},
  'assistance': {'ar': 'مساعدة', 'fr': 'Assistance', 'de': 'Unterstützung', 'es': 'Asistencia', 'it': 'Assistenza', 'tr': 'Yardım'},
  'need': {'ar': 'أحتاج', 'fr': 'Avoir besoin', 'de': 'Brauchen', 'es': 'Necesitar', 'it': 'Avere bisogno', 'tr': 'İhtiyacım var'},
  'want': {'ar': 'أريد', 'fr': 'Vouloir', 'de': 'Möchten', 'es': 'Querer', 'it': 'Volere', 'tr': 'İstiyorum'},
  'have': {'ar': 'عندي', 'fr': 'Avoir', 'de': 'Haben', 'es': 'Tener', 'it': 'Avere', 'tr': 'Sahip olmak'},
  'emergency': {'ar': 'طوارئ', 'fr': 'Urgence', 'de': 'Notfall', 'es': 'Emergencia', 'it': 'Emergenza', 'tr': 'Acil'},
  'police': {'ar': 'شرطة', 'fr': 'Police', 'de': 'Polizei', 'es': 'Policía', 'it': 'Polizia', 'tr': 'Polis'},
  'hospital': {'ar': 'مستشفى', 'fr': 'Hôpital', 'de': 'Krankenhaus', 'es': 'Hospital', 'it': 'Ospedale', 'tr': 'Hastane'},
  'doctor': {'ar': 'طبيب', 'fr': 'Médecin', 'de': 'Arzt', 'es': 'Médico', 'it': 'Medico', 'tr': 'Doktor'},
  'water': {'ar': 'ماء', 'fr': 'Eau', 'de': 'Wasser', 'es': 'Agua', 'it': 'Acqua', 'tr': 'Su'},
  'food': {'ar': 'طعام', 'fr': 'Nourriture', 'de': 'Essen', 'es': 'Comida', 'it': 'Cibo', 'tr': 'Yemek'},
  'restaurant': {'ar': 'مطعم', 'fr': 'Restaurant', 'de': 'Restaurant', 'es': 'Restaurante', 'it': 'Ristorante', 'tr': 'Restoran'},
  'bathroom': {'ar': 'حمام', 'fr': 'Toilettes', 'de': 'Toilette', 'es': 'Baño', 'it': 'Bagno', 'tr': 'Tuvalet'},
  'toilet': {'ar': 'مرحاض', 'fr': 'Toilettes', 'de': 'Toilette', 'es': 'Baño', 'it': 'Bagno', 'tr': 'Tuvalet'},
  'airport': {'ar': 'مطار', 'fr': 'Aéroport', 'de': 'Flughafen', 'es': 'Aeropuerto', 'it': 'Aeroporto', 'tr': 'Havalimanı'},
  'flight': {'ar': 'رحلة', 'fr': 'Vol', 'de': 'Flug', 'es': 'Vuelo', 'it': 'Volo', 'tr': 'Uçuş'},
  'plane': {'ar': 'طائرة', 'fr': 'Avion', 'de': 'Flugzeug', 'es': 'Avión', 'it': 'Aereo', 'tr': 'Uçak'},
  'ticket': {'ar': 'تذكرة', 'fr': 'Billet', 'de': 'Ticket', 'es': 'Boleto', 'it': 'Biglietto', 'tr': 'Bilet'},
  'boarding pass': {'ar': 'بطاقة صعود', 'fr': 'Carte d\'embarquement', 'de': 'Bordkarte', 'es': 'Tarjeta de embarque', 'it': 'Carta d\'imbarco', 'tr': 'Biniş kartı'},
  'passport': {'ar': 'جواز سفر', 'fr': 'Passeport', 'de': 'Reisepass', 'es': 'Pasaporte', 'it': 'Passaporto', 'tr': 'Pasaport'},
  'visa': {'ar': 'تأشيرة', 'fr': 'Visa', 'de': 'Visum', 'es': 'Visa', 'it': 'Visto', 'tr': 'Vize'},
  'luggage': {'ar': 'أمتعة', 'fr': 'Bagages', 'de': 'Gepäck', 'es': 'Equipaje', 'it': 'Bagaglio', 'tr': 'Bagaj'},
  'bag': {'ar': 'حقيبة', 'fr': 'Sac', 'de': 'Tasche', 'es': 'Bolsa', 'it': 'Borsa', 'tr': 'Çanta'},
  'suitcase': {'ar': 'حقيبة سفر', 'fr': 'Valise', 'de': 'Koffer', 'es': 'Maleta', 'it': 'Valigia', 'tr': 'Bavul'},
  'gate': {'ar': 'بوابة', 'fr': 'Porte', 'de': 'Gate', 'es': 'Puerta', 'it': 'Porta', 'tr': 'Kapı'},
  'terminal': {'ar': 'صالة', 'fr': 'Terminal', 'de': 'Terminal', 'es': 'Terminal', 'it': 'Terminale', 'tr': 'Terminal'},
  'security': {'ar': 'أمن', 'fr': 'Sécurité', 'de': 'Sicherheit', 'es': 'Seguridad', 'it': 'Sicurezza', 'tr': 'Güvenlik'},
  'check-in': {'ar': 'تسجيل الوصول', 'fr': 'Enregistrement', 'de': 'Check-in', 'es': 'Facturación', 'it': 'Check-in', 'tr': 'Check-in'},
  'departure': {'ar': 'مغادرة', 'fr': 'Départ', 'de': 'Abflug', 'es': 'Salida', 'it': 'Partenza', 'tr': 'Kalkış'},
  'arrival': {'ar': 'وصول', 'fr': 'Arrivée', 'de': 'Ankunft', 'es': 'Llegada', 'it': 'Arrivo', 'tr': 'Varış'},
  'delay': {'ar': 'تأخير', 'fr': 'Retard', 'de': 'Verspätung', 'es': 'Retraso', 'it': 'Ritardo', 'tr': 'Gecikme'},
  'cancelled': {'ar': 'ألغي', 'fr': 'Annulé', 'de': 'Annulliert', 'es': 'Cancelado', 'it': 'Cancellato', 'tr': 'İptal'},
  'boarding': {'ar': 'صعود', 'fr': 'Embarquement', 'de': 'Board', 'es': 'Embarque', 'it': 'Imbarco', 'tr': 'Biniş'},
  'telephone': {'ar': 'هاتف', 'fr': 'Téléphone', 'de': 'Telefon', 'es': 'Teléfono', 'it': 'Telefono', 'tr': 'Telefon'},
  'phone': {'ar': 'هاتف', 'fr': 'Téléphone', 'de': 'Telefon', 'es': 'Teléfono', 'it': 'Telefono', 'tr': 'Telefon'},
  'hotel': {'ar': 'فندق', 'fr': 'Hôtel', 'de': 'Hotel', 'es': 'Hotel', 'it': 'Hotel', 'tr': 'Otel'},
  'taxi': {'ar': 'سيارة أجرة', 'fr': 'Taxi', 'de': 'Taxi', 'es': 'Taxi', 'it': 'Taxi', 'tr': 'Taksi'},
  'bus': {'ar': 'حافلة', 'fr': 'Bus', 'de': 'Bus', 'es': 'Autobús', 'it': 'Autobus', 'tr': 'Otobüs'},
  'train': {'ar': 'قطار', 'fr': 'Train', 'de': 'Zug', 'es': 'Tren', 'it': 'Treno', 'tr': 'Tren'},
  'car': {'ar': 'سيارة', 'fr': 'Voiture', 'de': 'Auto', 'es': 'Coche', 'it': 'Macchina', 'tr': 'Araba'},
  'rental': {'ar': 'تأجير', 'fr': 'Location', 'de': 'Vermietung', 'es': 'Alquiler', 'it': 'Noleggio', 'tr': 'Kiralama'},
  'parking': {'ar': 'موقف سيارات', 'fr': 'Parking', 'de': 'Parkplatz', 'es': 'Estacionamiento', 'it': 'Parcheggio', 'tr': 'Otopark'},
  'currency': {'ar': 'عملة', 'fr': 'Monnaie', 'de': 'Währung', 'es': 'Moneda', 'it': 'Valuta', 'tr': 'Para birimi'},
  'money': {'ar': 'نقود', 'fr': 'Argent', 'de': 'Geld', 'es': 'Dinero', 'it': 'Denaro', 'tr': 'Para'},
  'exchange': {'ar': 'صرافة', 'fr': 'Change', 'de': 'Wechsel', 'es': 'Cambio', 'it': 'Cambio', 'tr': 'Döviz'},
  'atm': {'ar': 'صراف آلي', 'fr': 'Distributeur', 'de': 'Geldautomat', 'es': 'Cajero', 'it': 'Bancomat', 'tr': 'ATM'},
  'shop': {'ar': 'متجر', 'fr': 'Magasin', 'de': 'Geschäft', 'es': 'Tienda', 'it': 'Negozio', 'tr': 'Mağaza'},
  'pharmacy': {'ar': 'صيدلية', 'fr': 'Pharmacie', 'de': 'Apotheke', 'es': 'Farmacia', 'it': 'Farmacia', 'tr': 'Eczane'},
  'restroom': {'ar': 'مرحاض', 'fr': 'Toilettes', 'de': 'Toilette', 'es': 'Baño', 'it': 'Bagno', 'tr': 'Tuvalet'},
  'smoking': {'ar': 'تدخين', 'fr': 'Fumer', 'de': 'Rauchen', 'es': 'Fumar', 'it': 'Fumare', 'tr': 'Sigara'},
  'entrance': {'ar': 'مدخل', 'fr': 'Entrée', 'de': 'Eingang', 'es': 'Entrada', 'it': 'Ingresso', 'tr': 'Giriş'},
  'exit': {'ar': 'مخرج', 'fr': 'Sortie', 'de': 'Ausgang', 'es': 'Salida', 'it': 'Uscita', 'tr': 'Çıkış'},
  'open': {'ar': 'مفتوح', 'fr': 'Ouvert', 'de': 'Geöffnet', 'es': 'Abierto', 'it': 'Aperto', 'tr': 'Açık'},
  'closed': {'ar': 'مغلق', 'fr': 'Fermé', 'de': 'Geschlossen', 'es': 'Cerrado', 'it': 'Chiuso', 'tr': 'Kapalı'},
  'information': {'ar': 'معلومات', 'fr': 'Informations', 'de': 'Information', 'es': 'Información', 'it': 'Informazioni', 'tr': 'Bilgi'},
  'lost': {'ar': 'مفقود', 'fr': 'Perdu', 'de': 'Verloren', 'es': 'Perdido', 'it': 'Perso', 'tr': 'Kayıp'},
  'found': {'ar': 'موجود', 'fr': 'Trouvé', 'de': 'Gefunden', 'es': 'Encontrado', 'it': 'Trovato', 'tr': 'Bulundu'},
  'toilet paper': {'ar': 'ورق تواليت', 'fr': 'Papier toilette', 'de': 'Toilettenpapier', 'es': 'Papel higiénico', 'it': 'Carta igienica', 'tr': 'Tuvalet kağıdı'},
  'tissue': {'ar': 'منديل', 'fr': 'Mouchoir', 'de': 'Taschentuch', 'es': 'Pañuelo', 'it': 'Fazzoletto', 'tr': 'Mendil'},
  'wheelchair': {'ar': 'كرسي متحرك', 'fr': 'Fauteuil roulant', 'de': 'Rollstuhl', 'es': 'Silla de ruedas', 'it': 'Sedia a rotelle', 'tr': 'Tekerlekli sandalye'},
  'elevator': {'ar': 'مصعد', 'fr': 'Ascenseur', 'de': 'Aufzug', 'es': 'Ascensor', 'it': 'Ascensore', 'tr': 'Asansör'},
  'escalator': {'ar': 'سلم متحرك', 'fr': 'Escalator', 'de': 'Rolltreppe', 'es': 'Escalera', 'it': 'Scala mobile', 'tr': 'Yürüyen merdiven'},
  'stairs': {'ar': 'درج', 'fr': 'Escaliers', 'de': 'Treppe', 'es': 'Escaleras', 'it': 'Scale', 'tr': 'Merdiven'},
  'waiting room': {'ar': 'غرفة انتظار', 'fr': 'Salle d\'attente', 'de': 'Wartezimmer', 'es': 'Sala de espera', 'it': 'Sala d\'attesa', 'tr': 'Bekleme odası'},
  'nurse': {'ar': 'ممرضة', 'fr': 'Infirmière', 'de': 'Krankenschwester', 'es': 'Enfermera', 'it': 'Infermiera', 'tr': 'Hemşire'},
  'ambulance': {'ar': 'سيارة إسعاف', 'fr': 'Ambulance', 'de': 'Krankenwagen', 'es': 'Ambulancia', 'it': 'Ambulanza', 'tr': 'Ambulans'},
  'fire': {'ar': 'نار', 'fr': 'Feu', 'de': 'Feuer', 'es': 'Fuego', 'it': 'Fuoco', 'tr': 'Ateş'},
  'toothbrush': {'ar': 'فرشاة أسنان', 'fr': 'Brosse à dents', 'de': 'Zahnbürste', 'es': 'Cepillo de dientes', 'it': 'Spazzolino', 'tr': 'Diş fırçası'},
  'blanket': {'ar': 'بطانية', 'fr': 'Couverture', 'de': 'Decke', 'es': 'Manta', 'it': 'Coperta', 'tr': 'Battaniye'},
  'pillow': {'ar': 'وسادة', 'fr': 'Oreiller', 'de': 'Kissen', 'es': 'Almohada', 'it': 'Cuscino', 'tr': 'Yastık'},
  'headphones': {'ar': 'سماعات', 'fr': 'Casque', 'de': 'Kopfhörer', 'es': 'Auriculares', 'it': 'Cuffie', 'tr': 'Kulaklık'},
  'charger': {'ar': 'شاحن', 'fr': 'Chargeur', 'de': 'Ladegerät', 'es': 'Cargador', 'it': 'Caricabatterie', 'tr': 'Şarj aleti'},
  'wifi': {'ar': 'واي فاي', 'fr': 'WiFi', 'de': 'WLAN', 'es': 'WiFi', 'it': 'WiFi', 'tr': 'WiFi'},
  'internet': {'ar': 'إنترنت', 'fr': 'Internet', 'de': 'Internet', 'es': 'Internet', 'it': 'Internet', 'tr': 'İnternet'},
  'map': {'ar': 'خريطة', 'fr': 'Carte', 'de': 'Karte', 'es': 'Mapa', 'it': 'Mappa', 'tr': 'Harita'},
  'i': {'ar': 'أنا', 'fr': 'Je', 'de': 'Ich', 'es': 'Yo', 'it': 'Io', 'tr': 'Ben'},
  'me': {'ar': 'لي', 'fr': 'Moi', 'de': 'Mir', 'es': 'Me', 'it': 'Me', 'tr': 'Bana'},
  'my': {'ar': 'لي', 'fr': 'Mon', 'de': 'Mein', 'es': 'Mi', 'it': 'Mio', 'tr': 'Benim'},
  'you': {'ar': 'أنت', 'fr': 'Tu', 'de': 'Du', 'es': 'Tú', 'it': 'Tu', 'tr': 'Sen'},
  'we': {'ar': 'نحن', 'fr': 'Nous', 'de': 'Wir', 'es': 'Nosotros', 'it': 'Noi', 'tr': 'Biz'},
  'where': {'ar': 'أين', 'fr': 'Où', 'de': 'Wo', 'es': 'Dónde', 'it': 'Dove', 'tr': 'Nerede'},
  'when': {'ar': 'متى', 'fr': 'Quand', 'de': 'Wann', 'es': 'Cuándo', 'it': 'Quando', 'tr': 'Ne zaman'},
  'what': {'ar': 'ماذا', 'fr': 'Quoi', 'de': 'Was', 'es': 'Qué', 'it': 'Cosa', 'tr': 'Ne'},
  'who': {'ar': 'من', 'fr': 'Qui', 'de': 'Wer', 'es': 'Quién', 'it': 'Chi', 'tr': 'Kim'},
  'how much': {'ar': 'كم', 'fr': 'Combien', 'de': 'Wie viel', 'es': 'Cuánto', 'it': 'Quanto', 'tr': 'Ne kadar'},
  'how many': {'ar': 'كم عدد', 'fr': 'Combien', 'de': 'Wie viele', 'es': 'Cuántos', 'it': 'Quanti', 'tr': 'Kaç tane'},
  'why': {'ar': 'لماذا', 'fr': 'Pourquoi', 'de': 'Warum', 'es': 'Por qué', 'it': 'Perché', 'tr': 'Neden'},
  'time': {'ar': 'وقت', 'fr': 'Temps', 'de': 'Zeit', 'es': 'Tiempo', 'it': 'Tempo', 'tr': 'Zaman'},
  'today': {'ar': 'اليوم', 'fr': 'Aujourd\'hui', 'de': 'Heute', 'es': 'Hoy', 'it': 'Oggi', 'tr': 'Bugün'},
  'tomorrow': {'ar': 'غدا', 'fr': 'Demain', 'de': 'Morgen', 'es': 'Mañana', 'it': 'Domani', 'tr': 'Yarın'},
  'yesterday': {'ar': 'أمس', 'fr': 'Hier', 'de': 'Gestern', 'es': 'Ayer', 'it': 'Ieri', 'tr': 'Dün'},
  'morning': {'ar': 'صباح', 'fr': 'Matin', 'de': 'Morgen', 'es': 'Mañana', 'it': 'Mattina', 'tr': 'Sabah'},
  'afternoon': {'ar': 'بعد الظهر', 'fr': 'Après-midi', 'de': 'Nachmittag', 'es': 'Tarde', 'it': 'Pomeriggio', 'tr': 'Öğleden sonra'},
  'evening': {'ar': 'مساء', 'fr': 'Soir', 'de': 'Abend', 'es': 'Tarde', 'it': 'Sera', 'tr': 'Akşam'},
  'night': {'ar': 'ليل', 'fr': 'Nuit', 'de': 'Nacht', 'es': 'Noche', 'it': 'Notte', 'tr': 'Gece'},
  'monday': {'ar': 'الاثنين', 'fr': 'Lundi', 'de': 'Montag', 'es': 'Lunes', 'it': 'Lunedì', 'tr': 'Pazartesi'},
  'tuesday': {'ar': 'الثلاثاء', 'fr': 'Mardi', 'de': 'Dienstag', 'es': 'Martes', 'it': 'Martedì', 'tr': 'Salı'},
  'wednesday': {'ar': 'الأربعاء', 'fr': 'Mercredi', 'de': 'Mittwoch', 'es': 'Miércoles', 'it': 'Mercoledì', 'tr': 'Çarşamba'},
  'thursday': {'ar': 'الخميس', 'fr': 'Jeudi', 'de': 'Donnerstag', 'es': 'Jueves', 'it': 'Giovedì', 'tr': 'Perşembe'},
  'friday': {'ar': 'الجمعة', 'fr': 'Vendredi', 'de': 'Freitag', 'es': 'Viernes', 'it': 'Venerdì', 'tr': 'Cuma'},
  'saturday': {'ar': 'السبت', 'fr': 'Samedi', 'de': 'Samstag', 'es': 'Sábado', 'it': 'Sabato', 'tr': 'Cumartesi'},
  'sunday': {'ar': 'الأحد', 'fr': 'Dimanche', 'de': 'Sonntag', 'es': 'Domingo', 'it': 'Domenica', 'tr': 'Pazar'},
  'one': {'ar': 'واحد', 'fr': 'Un', 'de': 'Eins', 'es': 'Uno', 'it': 'Uno', 'tr': 'Bir'},
  'two': {'ar': 'اثنان', 'fr': 'Deux', 'de': 'Zwei', 'es': 'Dos', 'it': 'Due', 'tr': 'İki'},
  'three': {'ar': 'ثلاثة', 'fr': 'Trois', 'de': 'Drei', 'es': 'Tres', 'it': 'Tre', 'tr': 'Üç'},
  'four': {'ar': 'أربعة', 'fr': 'Quatre', 'de': 'Vier', 'es': 'Cuatro', 'it': 'Quattro', 'tr': 'Dört'},
  'five': {'ar': 'خمسة', 'fr': 'Cinq', 'de': 'Fünf', 'es': 'Cinco', 'it': 'Cinque', 'tr': 'Beş'},
  'six': {'ar': 'ستة', 'fr': 'Six', 'de': 'Sechs', 'es': 'Seis', 'it': 'Sei', 'tr': 'Altı'},
  'seven': {'ar': 'سبعة', 'fr': 'Sept', 'de': 'Sieben', 'es': 'Siete', 'it': 'Sette', 'tr': 'Yedi'},
  'eight': {'ar': 'ثمانية', 'fr': 'Huit', 'de': 'Acht', 'es': 'Ocho', 'it': 'Otto', 'tr': 'Sekiz'},
  'nine': {'ar': 'تسعة', 'fr': 'Neuf', 'de': 'Neun', 'es': 'Nueve', 'it': 'Nove', 'tr': 'Dokuz'},
  'ten': {'ar': 'عشرة', 'fr': 'Dix', 'de': 'Zehn', 'es': 'Diez', 'it': 'Dieci', 'tr': 'On'},
  'menu': {'ar': 'قائمة', 'fr': 'Menu', 'de': 'Speisekarte', 'es': 'Menú', 'it': 'Menu', 'tr': 'Menü'},
  'bill': {'ar': 'فاتورة', 'fr': 'Addition', 'de': 'Rechnung', 'es': 'Cuenta', 'it': 'Conto', 'tr': 'Hesap'},
  'coffee': {'ar': 'قهوة', 'fr': 'Café', 'de': 'Kaffee', 'es': 'Café', 'it': 'Caffè', 'tr': 'Kahve'},
  'tea': {'ar': 'شاي', 'fr': 'Thé', 'de': 'Tee', 'es': 'Té', 'it': 'Tè', 'tr': 'Çay'},
  'wine': {'ar': 'نبيذ', 'fr': 'Vin', 'de': 'Wein', 'es': 'Vino', 'it': 'Vino', 'tr': 'Şarap'},
  'beer': {'ar': 'بيرة', 'fr': 'Bière', 'de': 'Bier', 'es': 'Cerveza', 'it': 'Birra', 'tr': 'Bira'},
  'juice': {'ar': 'عصير', 'fr': 'Jus', 'de': 'Saft', 'es': 'Jugo', 'it': 'Succo', 'tr': 'Meyve suyu'},
  'bread': {'ar': 'خبز', 'fr': 'Pain', 'de': 'Brot', 'es': 'Pan', 'it': 'Pane', 'tr': 'Ekmek'},
  'chicken': {'ar': 'دجاج', 'fr': 'Poulet', 'de': 'Hähnchen', 'es': 'Pollo', 'it': 'Pollo', 'tr': 'Tavuk'},
  'rice': {'ar': 'أرز', 'fr': 'Riz', 'de': 'Reis', 'es': 'Arroz', 'it': 'Riso', 'tr': 'Pirinç'},
  'sugar': {'ar': 'سكر', 'fr': 'Sucre', 'de': 'Zucker', 'es': 'Azúcar', 'it': 'Zucchero', 'tr': 'Şeker'},
  'salt': {'ar': 'ملح', 'fr': 'Sel', 'de': 'Salz', 'es': 'Sal', 'it': 'Sale', 'tr': 'Tuz'},
  'cold': {'ar': 'بارد', 'fr': 'Froid', 'de': 'Kalt', 'es': 'Frío', 'it': 'Freddo', 'tr': 'Soğuk'},
  'hot': {'ar': 'حار', 'fr': 'Chaud', 'de': 'Heiß', 'es': 'Caliente', 'it': 'Caldo', 'tr': 'Sıcak'},
  'big': {'ar': 'كبير', 'fr': 'Grand', 'de': 'Groß', 'es': 'Grande', 'it': 'Grande', 'tr': 'Büyük'},
  'small': {'ar': 'صغير', 'fr': 'Petit', 'de': 'Klein', 'es': 'Pequeño', 'it': 'Piccolo', 'tr': 'Küçük'},
  'left': {'ar': 'يسار', 'fr': 'Gauche', 'de': 'Links', 'es': 'Izquierda', 'it': 'Sinistra', 'tr': 'Sol'},
  'right': {'ar': 'يمين', 'fr': 'Droite', 'de': 'Rechts', 'es': 'Derecha', 'it': 'Destra', 'tr': 'Sağ'},
  'straight': {'ar': 'مستقيم', 'fr': 'Tout droit', 'de': 'Geradeaus', 'es': 'Recto', 'it': 'Dritto', 'tr': 'Düz'},
  'here': {'ar': 'هنا', 'fr': 'Ici', 'de': 'Hier', 'es': 'Aquí', 'it': 'Qui', 'tr': 'Burada'},
  'there': {'ar': 'هناك', 'fr': 'Là', 'de': 'Dort', 'es': 'Allí', 'it': 'Lì', 'tr': 'Orada'},
  'near': {'ar': 'قريب', 'fr': 'Près', 'de': 'Nah', 'es': 'Cerca', 'it': 'Vicino', 'tr': 'Yakın'},
  'far': {'ar': 'بعيد', 'fr': 'Loin', 'de': 'Weit', 'es': 'Lejos', 'it': 'Lontano', 'tr': 'Uzak'},
  'now': {'ar': 'الآن', 'fr': 'Maintenant', 'de': 'Jetzt', 'es': 'Ahora', 'it': 'Adesso', 'tr': 'Şimdi'},
  'later': {'ar': 'فيما بعد', 'fr': 'Plus tard', 'de': 'Später', 'es': 'Después', 'it': 'Dopo', 'tr': 'Sonra'},
};

class TranslationRecord {
  final String id;
  final String sourceText;
  final String translatedText;
  final String sourceLang;
  final String targetLang;
  final String? detectedLang;
  final DateTime timestamp;

  const TranslationRecord({
    required this.id,
    required this.sourceText,
    required this.translatedText,
    required this.sourceLang,
    required this.targetLang,
    this.detectedLang,
    required this.timestamp,
  });

  factory TranslationRecord.fromJson(Map<String, dynamic> json) =>
      TranslationRecord(
        id: json['id'] as String,
        sourceText: json['sourceText'] as String,
        translatedText: json['translatedText'] as String,
        sourceLang: json['sourceLang'] as String,
        targetLang: json['targetLang'] as String,
        detectedLang: json['detectedLang'] as String?,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sourceText': sourceText,
        'translatedText': translatedText,
        'sourceLang': sourceLang,
        'targetLang': targetLang,
        'detectedLang': detectedLang,
        'timestamp': timestamp.toIso8601String(),
      };

  TranslationRecord copyWith({
    String? sourceText,
    String? translatedText,
    String? sourceLang,
    String? targetLang,
    String? detectedLang,
  }) =>
      TranslationRecord(
        id: id,
        sourceText: sourceText ?? this.sourceText,
        translatedText: translatedText ?? this.translatedText,
        sourceLang: sourceLang ?? this.sourceLang,
        targetLang: targetLang ?? this.targetLang,
        detectedLang: detectedLang ?? this.detectedLang,
        timestamp: timestamp,
      );
}

class TranslatorState {
  const TranslatorState({
    this.sourceLang = 'Auto',
    this.targetLang = 'English',
    this.sourceText,
    this.translatedText,
    this.detectedLang,
    this.isLoading = false,
    this.error,
    this.autoTranslate = false,
    this.history = const [],
    this.favorites = const [],
    this.isOnline = true,
    this.isListening = false,
    this.isSpeaking = false,
    this.translationDuration,
  });

  final String sourceLang;
  final String targetLang;
  final String? sourceText;
  final String? translatedText;
  final String? detectedLang;
  final bool isLoading;
  final String? error;
  final bool autoTranslate;
  final List<TranslationRecord> history;
  final List<TranslationRecord> favorites;
  final bool isOnline;
  final bool isListening;
  final bool isSpeaking;
  final Duration? translationDuration;

  TranslatorState copyWith({
    String? sourceLang,
    String? targetLang,
    String? sourceText,
    String? translatedText,
    String? detectedLang,
    bool? isLoading,
    String? error,
    bool? autoTranslate,
    List<TranslationRecord>? history,
    List<TranslationRecord>? favorites,
    bool? isOnline,
    bool? isListening,
    bool? isSpeaking,
    Duration? translationDuration,
    bool clearError = false,
    bool clearTranslatedText = false,
    bool clearDetectedLang = false,
  }) {
    return TranslatorState(
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      sourceText: sourceText ?? this.sourceText,
      translatedText:
          clearTranslatedText ? null : (translatedText ?? this.translatedText),
      detectedLang:
          clearDetectedLang ? null : (detectedLang ?? this.detectedLang),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      autoTranslate: autoTranslate ?? this.autoTranslate,
      history: history ?? this.history,
      favorites: favorites ?? this.favorites,
      isOnline: isOnline ?? this.isOnline,
      isListening: isListening ?? this.isListening,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      translationDuration:
          translationDuration ?? this.translationDuration,
    );
  }
}

class TranslatorNotifier extends StateNotifier<TranslatorState> {
  TranslatorNotifier(this._apiClient, this._storageService)
      : super(const TranslatorState()) {
    _loadPersistedState();
    _checkConnectivity();
  }

  final ApiClient _apiClient;
  final StorageService _storageService;
  Timer? _debounceTimer;

  Future<void> _loadPersistedState() async {
    try {
      final historyStr = _storageService.getString(_kHistoryKey);
      final favStr = _storageService.getString(_kFavoritesKey);

      final history = historyStr != null
          ? (jsonDecode(historyStr) as List)
              .map((e) => TranslationRecord.fromJson(e as Map<String, dynamic>))
              .toList()
          : const <TranslationRecord>[];
      final favorites = favStr != null
          ? (jsonDecode(favStr) as List)
              .map((e) => TranslationRecord.fromJson(e as Map<String, dynamic>))
              .toList()
          : const <TranslationRecord>[];

      if (!mounted) return;
      state = state.copyWith(history: history, favorites: favorites);
    } catch (_) {}
  }

  Future<void> _checkConnectivity() async {
    try {
      state = state.copyWith(isOnline: true);
    } catch (_) {
      state = state.copyWith(isOnline: false);
    }
  }

  Future<void> setSourceLang(String lang) async {
    state = state.copyWith(
      sourceLang: lang,
      clearError: true,
      clearDetectedLang: true,
    );
    if (state.autoTranslate && state.sourceText != null) {
      await _debouncedTranslate();
    }
  }

  Future<void> setTargetLang(String lang) async {
    state = state.copyWith(targetLang: lang, clearError: true);
    if (state.autoTranslate && state.sourceText != null) {
      await _debouncedTranslate();
    }
  }

  Future<void> toggleAutoTranslate() async {
    final newValue = !state.autoTranslate;
    state = state.copyWith(autoTranslate: newValue);
    if (newValue && state.sourceText != null && state.sourceText!.isNotEmpty) {
      await _debouncedTranslate();
    }
  }

  void onSourceTextChanged(String text) {
    state = state.copyWith(
      sourceText: text,
      clearError: true,
      clearTranslatedText: true,
      clearDetectedLang: true,
    );
    if (state.autoTranslate && text.trim().isNotEmpty) {
      _debouncedTranslate();
    }
  }

  Future<void> _debouncedTranslate() async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), translate);
  }

  Future<void> translate() async {
    final text = state.sourceText?.trim();
    if (text == null || text.isEmpty) {
      state = state.copyWith(clearTranslatedText: true, clearDetectedLang: true);
      return;
    }

    final sourceLangForApi = state.sourceLang == 'Auto' ? 'auto' : state.sourceLang;

    state = state.copyWith(
      isLoading: true,
      error: null,
      clearTranslatedText: true,
      clearDetectedLang: true,
    );

    final started = DateTime.now();

    try {
      final response = await _apiClient.dio.post(
        '/translator/translate/',
        data: {
          'text': text,
          'source_language': sourceLangForApi,
          'target_language': state.targetLang,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final translatedText = (data['translated_text'] ?? data['text'] ?? '') as String;
      final detectedLang = data['detected_language'] as String?;

      final duration = DateTime.now().difference(started);

      if (!mounted) return;
      state = state.copyWith(
        translatedText: translatedText,
        detectedLang: detectedLang,
        isLoading: false,
        translationDuration: duration,
      );

      await _addToHistory(text, translatedText);
    } catch (_) {
      final translatedText = _localTranslate(text, state.targetLang);
      final duration = DateTime.now().difference(started);
      final detectedLang = sourceLangForApi == 'auto' ? _detectLanguage(text) : null;

      if (!mounted) return;
      state = state.copyWith(
        translatedText: translatedText,
        detectedLang: detectedLang,
        isLoading: false,
        translationDuration: duration,
      );
      await _addToHistory(text, translatedText);
    }
  }

  String _localTranslate(String text, String targetLang) {
    final targetCode = _langCode[targetLang] ?? 'en';
    final lower = text.toLowerCase().trim();
    final words = lower.split(RegExp(r'\s+'));

    // 1. Exact phrase match first
    for (final entry in _wordDict.entries) {
      final phraseKey = entry.key;
      if (lower.contains(phraseKey)) {
        final translation = entry.value[targetCode];
        if (translation != null) {
          if (lower == phraseKey) return translation;
          return text.replaceAll(RegExp(phraseKey, caseSensitive: false), translation);
        }
      }
    }

    // 2. Word-by-word translation
    final translatedWords = <String>[];
    for (final word in words) {
      final cleaned = word.replaceAll(RegExp(r'[^\w\s]'), '');
      final match = _wordDict[cleaned];
      if (match != null && match[targetCode] != null) {
        translatedWords.add(match[targetCode]!);
      } else {
        translatedWords.add(cleaned);
      }
    }

    if (translatedWords.any((w) => w.contains(RegExp(r'[a-zA-Z]')))) {
      return translatedWords.join(' ');
    }

    // 3. If some words were translated, show result with marker
    if (translatedWords.isNotEmpty) {
      return translatedWords.join(' ');
    }

    return '[$targetLang] $text';
  }

  String _detectLanguage(String text) {
    final arabic = RegExp(r'[\u0600-\u06FF]');
    final turkishChars = RegExp(r'[ğüşıöçĞÜŞİÖÇ]');
    final frenchWords = {'bonjour', 'merci', 's\'il vous plaît', 'au revoir', 'oui', 'non'};
    final spanishWords = {'hola', 'gracias', 'adiós', 'por favor', 'sí', 'no'};
    final germanWords = {'hallo', 'danke', 'tschüss', 'bitte', 'ja', 'nein'};
    final italianWords = {'ciao', 'grazie', 'arrivederci', 'per favore', 'sì', 'no'};
    final lower = text.toLowerCase().trim();

    if (arabic.hasMatch(text)) return 'Arabic';
    if (turkishChars.hasMatch(text)) return 'Turkish';
    if (frenchWords.any((w) => lower.startsWith(w))) return 'French';
    if (spanishWords.any((w) => lower.startsWith(w))) return 'Spanish';
    if (germanWords.any((w) => lower.startsWith(w))) return 'German';
    if (italianWords.any((w) => lower.startsWith(w))) return 'Italian';

    return 'English';
  }

  Future<void> _addToHistory(String source, String target, {String? detectedLang}) async {
    final record = TranslationRecord(
      id: '${DateTime.now().millisecondsSinceEpoch}_$source',
      sourceText: source,
      translatedText: target,
      sourceLang: state.sourceLang,
      targetLang: state.targetLang,
      detectedLang: detectedLang ?? state.detectedLang,
      timestamp: DateTime.now(),
    );

    final newHistory = [record, ...state.history].take(10).toList();
    state = state.copyWith(history: newHistory);
    await _storageService.setString(_kHistoryKey, jsonEncode(newHistory));
  }

  Future<void> toggleFavorite(String? id) async {
    if (id == null) return;
    final item = state.history.where((r) => r.id == id).firstOrNull;
    if (item == null) return;

    final exists = state.favorites.any((r) => r.id == id);
    final newFavs = exists
        ? state.favorites.where((r) => r.id != id).toList()
        : [...state.favorites, item];

    state = state.copyWith(favorites: newFavs);
    await _storageService.setString(_kFavoritesKey, jsonEncode(newFavs));
  }

  Future<void> clearHistory() async {
    state = state.copyWith(history: const []);
    await _storageService.remove(_kHistoryKey);
  }

  Future<void> clearFavorites() async {
    state = state.copyWith(favorites: const []);
    await _storageService.remove(_kFavoritesKey);
  }

  void swapLanguages() {
    if (state.sourceLang == 'Auto') return;
    final tempText = state.translatedText;
    state = state.copyWith(
      sourceLang: state.targetLang,
      targetLang: state.sourceLang,
      sourceText: tempText,
      translatedText: state.sourceText,
      detectedLang: null,
      clearError: true,
    );
  }

  void toggleListening() {
    state = state.copyWith(isListening: !state.isListening);
  }

  void toggleSpeaking() {
    state = state.copyWith(isSpeaking: !state.isSpeaking);
  }

  void clearError() => state = state.copyWith(error: null);

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final translatorStateProvider =
    StateNotifierProvider<TranslatorNotifier, TranslatorState>((ref) {
  return TranslatorNotifier(
    ref.watch(apiClientProvider),
    ref.watch(storageServiceProvider),
  );
});

final languagesProvider = Provider<List<String>>((ref) => _languages);
