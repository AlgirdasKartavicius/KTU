<?php

	// sukuriame užsakymo prekių klasės objektą
	include 'libraries/UzsakymoPreke.class.php';
	$uzsakymoPrekeObj = new UzsakymoPreke();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);

	if(!empty($removeId)) {
		$removeErrorParameter = '';
		
		// šaliname užsakymo prekę
		$uzsakymoPrekeObj->deleteUzsakymoPreke($removeId);

		// nukreipiame į užsakymo prekių puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Užsakymo prekės</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Nauja užsakymo prekė</a>
</div>
<div class="float-clear"></div>

<table>
	<tr>
		<th>Kiekis</th>
		<th>Užsakymo numeris</th>
		<th>Prekės kodas</th>
		<th></th>
	</tr>
	<?php
		// suskaičiuojame bendrą įrašų kiekį
		$elementCount = $uzsakymoPrekeObj->getUzsakymoPrekeListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio automobilius
		$data = $uzsakymoPrekeObj->getUzsakymoPrekeList($paging->size, $paging->first);

		// suformuojame lentelę
		foreach($data as $key => $val) {
			echo
				"<tr>"
					. "<td>{$val['kiekis']}</td>"
					. "<td>{$val['uzsakymas']}</td>"
					. "<td>{$val['preke']}</td>"
					. "<td>"
						. "<a href='#' onclick='showConfirmDialog(\"{$module}\", \"{$val['id']}\"); return false;' title=''>šalinti</a>&nbsp;"
						. "<a href='index.php?module={$module}&id={$val['id']}' title=''>redaguoti</a>"
					. "</td>"
				. "</tr>";
		}
	?>
</table>

<?php
	// įtraukiame puslapių šabloną
	include 'controls/paging.php';
?>