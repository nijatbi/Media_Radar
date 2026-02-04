import 'package:flutter/material.dart';

class AdvancedSearchPanel extends StatefulWidget {
  const AdvancedSearchPanel({super.key});

  @override
  State<AdvancedSearchPanel> createState() => _AdvancedSearchPanelState();
}

class _AdvancedSearchPanelState extends State<AdvancedSearchPanel> {
  String selectedCategory = 'Hamısı';
  bool isLocalSource = false;
  bool isGlobalSource = false;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Açar sözlər Inputu
                TextField(
                  decoration: InputDecoration(
                    hintText: "Açar sözləri daxil edin...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      items: <String>['Hamısı', 'Siyasət', 'İqtisadiyyat', 'Texnologiya']
                          .map((String value) => DropdownMenuItem(value: value, child: Text(value)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedCategory = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tarix seçimi
                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20, color: Colors.green),
                        const SizedBox(width: 10),
                        Text(selectedDate == null
                            ? "Tarix seçin"
                            : "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Mənbə növü - Checkbox hissəsi
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text("Yerli", style: TextStyle(fontSize: 13)),
                        value: isLocalSource,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) => setState(() => isLocalSource = val!),
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text("Xarici", style: TextStyle(fontSize: 13)),
                        value: isGlobalSource,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) => setState(() => isGlobalSource = val!),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Düymə
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF23C98D),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {},
                    child: const Text("Axtar", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}