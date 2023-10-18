import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeneficiaryState extends ChangeNotifier {
  String? _value = 'Beneficiary';

  String? get value => _value;

  set value(String? newValue) {
    _value = newValue;
    notifyListeners();
  }
}

void beneficiaryPopupMenu(BuildContext context, beneficiaryState) {
  final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
  final RenderBox button = context.findRenderObject() as RenderBox;

  final double topOffset = 500; // Adjust this value as needed
  final double leftOffset = 550; // Adjust this value as needed

  final position = RelativeRect.fromLTRB(
    leftOffset,
    topOffset,
    leftOffset + button.size.width,
    topOffset + button.size.height,
  );

  final beneficiaryItems = ['Beneficiary',
    'A W M Riza',
    'Academy of Digital Business Pvt. Ltd',
    'Ajay Hathiramani',
    'Andea Pereira',
    'Andrew Downal',
    'Asanga Karunarathne',
    'Ashish Debey',
    'Askalu Lanka Pvt. Ltd',
    'Axis Tech Lanka (Pvt) Ltd',
    'B C M Azwath',
    'Ceylon Secretarial Services Pvt. Ltd',
    'Codify Lanka Pvt. Ltd',
    'Colonel Sujith Jayasekera',
    'Compume (Pvt) Ltd',
    'Corporate Business Solutions Pvt. Ltd',
    'Courtesy Law Lanka Pvt. Ltd',
    'Damith Gangodawilage',
    'David Murray',
    'DBA Alumni',
    'Deepani Attanayake',
    'Denver De Zylva',
    'Deshan Senadheera',
    'Dilhan Fernando',
    'Dinoo Perera',
    'Directpay (Pvt) Ltd',
    'DN Thurairajah & Co.',
    'Dr. Ishantha Jayasekera',
    'Dr. Shahani Markus',
    'E A Bimal Silva',
    'Eksath Perera',
    'Emojot Inc.',
    'Emojot Pvt. Ltd',
    'Fawas Ashraff',
    'Fernando Ventures Pvt. Ltd',
    'GK Wijayananada',
    'Gullies Beauty Care',
    'Hemal Kannangara',
    'Himali De Silva',
    'Idak Ceylon (Pvt) Ltd',
    'Imate Construction',
    'Ishan Dantanarayana',
    'Jagath Pathirane',
    'Jithain Hathiramani',
    'JK Chambers/Kanchana Senanayake',
    'Kalpitiya Discovery Diving Pvt. Ltd',
    'Kelsey Services/Kavan Weerasinghe',
    'L.D Wijerathne',
    'Lloyd Mills Pvt Ltd',
    'Lowcodeminds (Pvt) Ltd',
    'M R Muthalif',
    'Madu Rathnayake',
    'Maithri Liyange',
    'Mars Global Services Pvt. Ltd',
    'Maryse Perers',
    'Media Box/Ayesha',
    'Migara Perera',
    'Milinda Wattegerda',
    'Mithun Liyanage',
    'Mr. Lakshman Jayathilake',
    'Nature Confort Lanka Holdings Pvt. Ltd',
    'Nausha Raheem',
    'Naveen Wijetunga',
    'Nilangani De Silva',
    'Nirmana Traders/Surath Herath',
    'Nitmark Technologies Pvt. Ltd',
    'Nugawela Transport',
    'Off2 Lanka',
    'Paymedia Pvt. Ltd',
    'Pelicancube (Pvt) Ltd',
    'Pradipa Jayathilaka',
    'Prasanna Wijesiri',
    'Rajeeve Goonetileke',
    'Rasanga Shanaka',
    'Ravin',
    'Reena',
    'Ruchika Roonahewa',
    'Rumesh Athukorala',
    'Sachnitha Rajith Ponnamperuma',
    'Saliya Silva',
    'Samantha Maithriwardena',
    'Sameera Subashingha',
    'Sampath Gunawardena',
    'Sanjeeva Abyewardena',
    'Sayura Beer Shop/Sunil Punchibandara',
    'Shanil Fernando',
    'Shirani Kulasinghe',
    'Sonali Wicremaratne',
    'Squarehub (Pvt) Ltd',
    'Stephen Paulraj',
    'Sumudu Kumara Gunawarden',
    'Suren Karunakaran',
    'Tanya Gunasekera',
    'Taxperts Lanka Pvt. Ltd',
    'Tesman Melani',
    'Tharaka',
    'Tharumal Wijesimghe',
    'The Embazzy',
    'The Headmasters Pvt. Ltd',
    'Thingerbits Pvt. Ltd',
    'Tikiri Banda & Sons/Dr. Bandara',
    'Univiser (Pvt) Ltd',
    'UP Weerasinghe Properties Pvt. Ltd']; // Add your beneficiary items here

  final popupMenuItems = beneficiaryItems.map<PopupMenuItem<int>>((String value) {
    return PopupMenuItem<int>(
      value: beneficiaryItems.indexOf(value), // Using the index as the value
      child: TextButton(
        onPressed: () {
          Navigator.pop(context, beneficiaryItems.indexOf(value)); // Return the index as the result
        },
        child: Text(value),
      ),
    );
  }).toList();

  showMenu(
    context: context,
    position: position,
    items: popupMenuItems,
    elevation: 8,
  ).then((value) {
    if (value != null && value >= 0 && value < beneficiaryItems.length) {
      final selectedValue = beneficiaryItems[value];
      final beneficiaryState = Provider.of<BeneficiaryState>(context, listen: false);
      beneficiaryState.value = selectedValue;
      print('Selected Beneficiary: $selectedValue');
    }
  });
}
