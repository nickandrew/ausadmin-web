all:
	@echo Try \"make package\"

package:
	fakeroot debian/rules binary

dist:
	@echo Updating our distribution
	@~/bin/add-package-tullnet.sh
