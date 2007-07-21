all:
	@echo Try \"make distribution\" or \"make package\"

package:
	fakeroot debian/rules binary

dist:
	@echo Updating our distribution
	@~/bin/add-package-tullnet.sh

distribution:	.dist
	@echo "Distribution complete."

.dist:
	$(MAKE) ausadmin-website.tar.gz
	touch .dist

ausadmin-website.tar.gz:
	tar -z -c -v \
		-f /tmp/ausadmin-website.tar.gz \
		--exclude 'CVS' \
		--exclude 'Charters' \
		--exclude 'Deletions' \
		--exclude 'Stats' \
		--exclude 'Wip' \
		--exclude 'ausadmin.tar' \
		--exclude 'download' \
		--exclude 'logs' \
		--exclude 'test.php' \
		*
