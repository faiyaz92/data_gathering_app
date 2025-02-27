import 'package:flutter/material.dart';
import 'package:requirment_gathering_app/data/company.dart';
import 'package:requirment_gathering_app/utils/AppColor.dart';
import 'package:requirment_gathering_app/utils/AppLabels.dart';
import 'package:requirment_gathering_app/utils/text_styles.dart';

class FiltersSection extends StatelessWidget {
  final Function(String?) onCountrySelected;
  final Function(String?) onCitySelected;
  final Function(String?) onInterestLevelSelected;
  final Function(bool?) onEmailSentSelected;
  final Function(bool?) onEmailRepliedSelected;
  final Function(String?) onPrioritySelected;
  final Function(String?) onSourceSelected;
  final Function(String?) onSortSelected;
  final VoidCallback onClearFilters;

  final List<String> countries;
  final List<String> cities;
  final List<String> interestLevels;
  final List<String> priorities;
  final List<String> sources;
  final Company? company;

  const FiltersSection({
    Key? key,
    required this.onCountrySelected,
    required this.onCitySelected,
    required this.onInterestLevelSelected,
    required this.onEmailSentSelected,
    required this.onEmailRepliedSelected,
    required this.onPrioritySelected,
    required this.onSourceSelected,
    required this.onSortSelected,
    required this.onClearFilters,
    required this.countries,
    required this.cities,
    required this.interestLevels,
    required this.priorities,
    required this.sources,
    required this.company,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Filters",
              style:
              defaultTextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(child: _buildCountryField()),
                const SizedBox(width: 8),
                Expanded(child: _buildCityField()),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: interestLevels.contains(company?.interestLevel)
                        ? company?.interestLevel
                        : null,
                    items: interestLevels
                        .map((level) => DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    ))
                        .toList(),
                    onChanged: onInterestLevelSelected,
                    decoration: const InputDecoration(
                      labelText: AppLabels.interestLevelLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: priorities.contains(company?.priority)
                        ? company?.priority
                        : null,
                    items: priorities
                        .map((priority) => DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    ))
                        .toList(),
                    onChanged: onPrioritySelected,
                    decoration: const InputDecoration(
                      labelText: AppLabels.priorityLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: const Text(AppLabels.emailSentLabel),
                    value: company?.emailSent ?? false,
                    onChanged: onEmailSentSelected,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SwitchListTile(
                    title: const Text(AppLabels.theyRepliedLabel),
                    value: company?.theyReplied ?? false,
                    onChanged: onEmailRepliedSelected,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: sources.contains(company?.source)
                        ? company?.source
                        : null,
                    items: sources
                        .map((source) => DropdownMenuItem(
                      value: source,
                      child: Text(source),
                    ))
                        .toList(),
                    onChanged: onSourceSelected,
                    decoration: const InputDecoration(
                      labelText: AppLabels.sourceLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onClearFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deleteButtonColor,
                  ),
                  child: Text(
                    "Clear Filters",
                    style: defaultTextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert), // Sort icon
                  tooltip: AppLabels.sortOptionsTooltip,
                  onSelected: (value) {
                    onSortSelected(value); // Pass the selected value to the callback
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: AppLabels.sortLatest,
                      child: Text(AppLabels.sortByLatest),
                    ),
                    const PopupMenuItem(
                      value: AppLabels.sortOldest,
                      child: Text(AppLabels.sortByOldest),
                    ),
                    const PopupMenuItem(
                      value: AppLabels.sortHighToLowInterest,
                      child: Text(AppLabels.sortHighToLowInterestLabel),
                    ),
                    const PopupMenuItem(
                      value: AppLabels.sortLowToHighInterest,
                      child: Text(AppLabels.sortLowToHighInterestLabel),
                    ),
                  ],
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryField() {
    final countries = company?.settings?.countryCityMap.keys.toList() ?? [];
    return DropdownButtonFormField<String>(
      value: company?.country,
      items: countries
          .map((country) =>
          DropdownMenuItem(value: country, child: Text(country)))
          .toList(),
      onChanged: (selectedCountry) {
        if (selectedCountry != null) {
          onCountrySelected(selectedCountry);
        }
      },
      decoration: const InputDecoration(
        labelText: AppLabels.countryLabel,
        hintText: AppLabels.countryHint,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCityField() {
    final selectedCountry = company?.country;
    final cities = company?.settings?.countryCityMap[selectedCountry] ?? [];
    return DropdownButtonFormField<String>(
      value: cities.contains(company?.city) ? company?.city : null,
      items: cities
          .map((city) => DropdownMenuItem(value: city, child: Text(city)))
          .toList(),
      onChanged: onCitySelected,
      decoration: const InputDecoration(
        labelText: AppLabels.cityLabel,
        hintText: AppLabels.cityHint,
        border: OutlineInputBorder(),
      ),
    );
  }
}
