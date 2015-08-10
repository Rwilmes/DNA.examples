#!/bin/bash

source config.sh



OIFS=$IFS
IFS="/"
elements=()
for a in $1; do
	elements+=("$a")
done
IFS=$OIFS

nav=""
back=""
for (( i=${#elements[@]}-1; i>0; i-- )); do
	nav=" - <a href='${back}index.html'>${elements[$i]}</a>$nav"
	back="../$back"
done
nav="<a href='${back}index.html'>dna.example</a>$nav"
IFS=$OIFS


if [[ -f $javaDir$1.java ]]; then

	echo "<html>"
	echo '<head>'
	echo '	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />'
	echo '	<title>Hello SyntaxHighlighter</title>'
	echo '	<script type="text/javascript" src="../../../html/syntaxhighlighter_3.0.83/scripts/shCore.js"></script>'
	echo '	<script type="text/javascript" src="../../../html/syntaxhighlighter_3.0.83/scripts/shBrushJava.js"></script>'
	echo '	<link type="text/css" rel="stylesheet" href="../../../html/syntaxhighlighter_3.0.83/styles/shCoreEclipse.css"/>'
	echo '	<script type="text/javascript">SyntaxHighlighter.all();</script>'
	echo '</head>'

	echo "<body>$nav<br></br>"
	echo "<h1>${elements[${#elements[@]} - 1]}</h1>"

	#echo '<table><tr><td colspan="2">'
	echo "<h2>DESCRIPTION</h2>"
	echo '<pre style="background-color: #f0f0f0; border-style:dashed; border-width: 1px;">'
	cat $javaDir$1.java | grep "\*" | grep -v "/\*" | grep -v "\*/" | grep -v "@author" | sed 's/ \* //g' | sed 's/ \*//'
	echo "</pre>"
	#echo '</td></tr><tr><td>'
	echo "<h2>CODE</h2>"
	echo '<pre style="height: auto; max-height: 300px; overflow: auto; border-style:dashed; border-width: 1px;">'
	echo '<pre class="brush: java;">'
	cat $javaDir$1.java | sed -e '1,/@Override/d' | sed \$d | sed 's/	//'
	echo "</pre>"
	echo "</pre>"
	echo '</td><td>'

	if [[ -f $outputDir$1/log ]]; then
		echo "<h2>LOG OUTPUT</h2>"
		echo '<pre style="height: auto; max-height: 300px; overflow: auto; background-color: #f0f0f0; border-style:dashed; border-width: 1px;">'
		cat $outputDir$1/log
		echo "</pre>"
	fi

	if [[ -d $outputDir$1/$dataDir/ ]]; then
		echo "<h2>DATA</h2>"
		echo "<ul>"
		for a in $(ls $outputDir$1/$dataDir); do
			echo "<li> <a href='$dataDir/$a'>$a</a> </li>"
		done
		echo "</ul>"
	fi

	if [[ -d $outputDir$1/$plotDir/ ]]; then
		echo "<h2>PLOTS</h2>"
		for a in $(ls $outputDir$1/$plotDir/ | grep '.png\|.pdf'); do
			echo "<a href='$plotDir/$a'><img src='$plotDir/$a' width='200'/></a>"
		done
	fi

	if [[ -d $outputDir$1/$snapshotDir/ ]]; then
		echo "<h2>SNAPSHOTS</h2>"
		for a in $(ls $outputDir$1/$snapshotDir/); do
			echo "<a href='$shapshotDir/$a'><img src='$snapshotDir/$a' width='200'/></a>"
		done
	fi

	if [[ -d $outputDir$1/$outDir/ ]]; then
		echo "<h2>OUT</h2>"
		echo "<ul>"
		for a in $(ls $outputDir$1/$outDir); do
			echo "<li> <a href='$outDir/$a'>$a</a> </li>"
		done
		echo "</ul>"
	fi

	#echo '</td></tr></table>'

	echo "</body>"
	echo "</html>"
else
	echo "<html><body>$nav<br></br>"
	if [[ ${#elements[@]} -ge 2 ]]; then
		echo "<h1>${elements[${#elements[@]} - 1]}</h1>"
	else
		echo "<h1>dna.example</h1>"
	fi
	echo "<ul>"
	for a in $(ls $outputDir/$1); do
		if [[ "index.html" != $a ]]; then
			echo "<li><a href='$a/index.html'>$a</a></li>"
		fi
	done
	echo '</ul></body></html>'
fi