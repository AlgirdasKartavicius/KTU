<?php

	// sukuriame siuntų klasės objektą
	include 'libraries/Siunta.class.php';
	$SiuntaObj = new Siunta();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);

	if(!empty($removeId)) {
		$removeErrorParameter = '';
		
		// šaliname siuntą
		$SiuntaObj->deleteSiunta($removeId);

		// nukreipiame į siuntų puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Siuntos</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Nauja siunta</a>
</div>
<div class="float-clear"></div>

<table>
	<tr>
		<th>Kodas</th>
		<th>Pakuotės dydis</th>
		<th>Pirkėjo kodas</th>
		<th>Asistento tabelio nr.</th>
		<th>Užsakymas</th>
		<th>Tarnyba</th>
		<th></th>
	</tr>
	<?php
		// suskaičiuojame bendrą įrašų kiekį
		$elementCount = $SiuntaObj->getSiuntaListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio automobilius
		$data = $SiuntaObj->getSiuntaList($paging->size, $paging->first);

		// suformuojame lentelę
		foreach($data as $key => $val) {
			echo
				"<tr>"
					. "<td>{$val['kodas']}</td>"
					. "<td>{$val['pakuotesDydis']}</td>"
					. "<td>{$val['pirkejas']}</td>"
					. "<td>{$val['aptarnaujantisAsistentas']}</td>"
					. "<td>{$val['uzsakymas']}</td>"
					. "<td>{$val['tarnyba']}</td>"
					. "<td>"
						. "<a href='#' onclick='showConfirmDialog(\"{$module}\", \"{$val['kodas']}\"); return false;' title=''>šalinti</a>&nbsp;"
						. "<a href='index.php?module={$module}&id={$val['kodas']}' title=''>redaguoti</a>"
					. "</td>"
				. "</tr>";
		}
	?>
</table>

<?php
	// įtraukiame puslapių šabloną
	include 'controls/paging.php';
?>