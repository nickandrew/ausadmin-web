<?php

	require_once('lib/setup.inc');
	require_once('lib/subs.inc');

	# Get a list of "existing" newsgroups

	$array = files_in_dir("$AUSADMIN_HOME/data/Newsgroups");

	sort($array);

?>

<html>
<head>
<title>aus.* Newsgroup Administration</title>
</head>
<!-- $Source$ -->
<!-- $Revision$ -->
<!-- $Date$ -->

<body bgcolor="#ffffff" vlink="#336633" link="#6666cc"> 

<table width="600" cellpadding="0" cellspacing="0" border="0">
 <tr>
  <td bgcolor="#ffffe0" width="100" valign="top">
   <font size="-1">
    <?php require("lib/ausadmin_hdr.inc") ?>
    <?php require("lib/proposals.inc") ?>
    <?php print_group_list("Newsgroups:", $array); ?>
   </font>
  </td>

  <!-- Next column -->
  <td valign="top">
   <center>
    <h1>
     <font face=sans-serif>aus.* Newsgroup Administration</font>
    </h1>
   </center>

   <table cellpadding=5 cellspacing=0 width=100% border=0>

    <tr bgcolor="#000000">
     <td>
      <font size=+1 color="#66cc66" face=sans-serif><b>Overview</b></font>
     </td>
    </tr>

    <tr>
     <td>
      <p>The aus.* newsgroup administration is a volunteer effort to maintain
    and develop the aus.* USENET newsgroup hierarchy. We will achieve this by
    setting a clear policy for the growth of Australian newsgroups,
    managing the creation and deletion of newsgroups according to this
    policy, and providing online information to support the development
    of Australian newsgroups as a national resource.</p>

      <p>The aus.* administrator is currently
    Nick Andrew (<a href="http://www.nick-andrew.net">www.nick-andrew.net</a>),
    and operational staff and facilities are provided by
    <a href="http://www.tull.net/">Tullnet Pty Ltd</a>.

      <p>We wish to automate the administration task as much as possible.
    Before sending any questions by email make sure you have read the
    relevant FAQs and are aware of our current policy. This web site
    should cover most, if not all, queries you may have. If something
    seems important to you and it's not available here then please send
    some email.</p>

      <br>
     </td>
    </tr>

    <tr bgcolor="#000000">
     <td>
      <font size=+1 color="#66cc66" face=sans-serif><b>ausadmin Role</b></font>
     </td>
    </tr>

    <tr>
     <td>
      <ul>
       <li>Determine a good long-term structure for the aus.* hierarchy
       <li>Accept newsgroup proposals which fit the policy and structure
       <li>Final decision on newsgroup creation by voting
       <li>Slowly purge obsolete groups
       <li>Encourage news admins to respond to ausadmin newgroup and rmgroup messages
      </ul>
      <br>
     </td>
    </tr>

    <tr bgcolor="#000000">
     <td>
      <font size=+1 color="#66cc66" face=sans-serif><b>aus.* structure planning</b></font>
     </td>
    </tr>

    <tr>
     <td>
      <p>
       In other words, what extensions to the structure does ausadmin consider
       good or bad?
      </p>

      <p>Encouraged:</p>
      <ul>
       <li>aus.books extended by genre, or purpose (e.g. reviews)
       <li>aus.cars extended by manufacturer (not model)
       <li>aus.net.access extended by access technology name (e.g. adsl)
       <li>aus.politics extended by major philosophy (e.g. socialism -- but no crossposting)
       <li>aus.sport extensions include competitive activities
       <li>aus.rec extended by recreational non-competitive activies
       <li>aus.tv extended by genre or technology
      </ul>

      <p>Discouraged:</p>
      <ul>
       <li>Forsale groups outside the aus.ads hierarchy
       <li>All binary groups are discouraged (post a URL instead)
       <li>Regional subgroups, e.g. aus.motorcycles.wa (see wa.* and other regional hierarchies)
       <li>aus.org subgroups
       <li>aus.tv subgroups for particular shows
      </ul>

      <p>In general, be aware if the topic you are proposing can be discussed
      from another perspective within an existing aus.* group, for example
      aus.books.sf may be discussed in aus.sf already.
      </p>
      <br>
     </td>
    </tr>

    <tr bgcolor="#000000">
     <td>
      <font size=+1 color="#66cc66" face=sans-serif><b>ausadmin Policy</b></font>
     </td>
    </tr>

    <tr>
     <td>
      <ul>
       <li>Newsgroup creation only (no newsgroup deletions yet)
       <li>Unmoderated newsgroup creation only
       <li>Proposals considered by ausadmin to be frivolous or intended to "work the system" will be rejected
       <li>No change of newsgroups from unmoderated to moderated (it caused a terrible storm last time)
       <li>2-level newsgroups (aus.X) accepted only for major categories (e.g. science, arts, sport, humanities -- most of which exist already)
       <li>3-level newsgroups (aus.X.Y) accepted only when parent exists (aus.X) or a sibling group already exists (aus.X.Z)
       <li>The effect of the above two rules is that if you want a new group e.g. <i>aus.language.strine</i> with no existing parent and no siblings, then you need to first work on getting <i>aus.language</i> created, and that group will have to make do for strine discussions as well as other language discussions. You would then wait 1-2 years before proposing <i>aus.language.strine</i>.
       <li>No change of charter yet, but if you wish to propose a charter for an existing group which does not already have a charter, email it in and ausadmin will consider accepting it directly as the new charter.
      </ul>
      <br>
     </td>
    </tr>

    <tr bgcolor="#000000">
     <td>
      <font size=+1 color="#66cc66" face=sans-serif><b>Links</b></font>
     </td>
    </tr>

    <tr>
     <td>
      <a href="ftp://rtfm.mit.edu/pub/usenet-by-hierarchy/aus/">aus.* FAQs on rtfm.mit.edu</a><br>
      <a href="http://mirror.aarnet.edu.au/pub/rtfm/usenet-by-hierarchy/aus/">aus.* FAQs on mirror.aarnet.edu.au (local mirror of rtfm)</a><br>
      <br>
     </td>
    </tr>

    <tr bgcolor="#000000">
     <td>
      <font size=+1 color="#66cc66" face=sans-serif><b>Templates for newsgroup proposals</b></font>
     </td>
    </tr>

    <tr>
     <td>
      <p>
       Be sure to read the
       <a href="/Faq/aus_faq">Group&nbsp;creation&nbsp;FAQ</a>
       before applying for a new newsgroup.
      </p>
       <a href="Faq/RFD-template.txt">Template for writing an RFD (Request For Discussion)</a></br>
      <br>
     </td>
    </tr>


   </table>
  </td>
 </table>

</body>
</html>
