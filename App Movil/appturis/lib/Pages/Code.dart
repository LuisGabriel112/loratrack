/*List<Widget> _buildSections() {
    return List.generate(_sectionTitles.length, (index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _sectionExpanded[index] = !_sectionExpanded[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    _sectionTitles[index],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    _sectionExpanded[index]
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Column(children: _generateOptions(index)),
            crossFadeState:
                _sectionExpanded[index]
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
        ],
      );
    });
  }
  
  
    List<Widget> _buildSections() {
    return List.generate(_sectionTitles.length, (index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _sectionExpanded[index] = !_sectionExpanded[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    _sectionTitles[index],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    _sectionExpanded[index]
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            // Reemplaza AnimatedCrossFade con Visibility
            visible: _sectionExpanded[index],
            child: Column(children: _generateOptions(index)),
          ),
        ],
      );
    });
  }
  
  
  */
