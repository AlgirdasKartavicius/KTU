<?php

	// sukuriame sąskaitų klasės objektą
	include 'libraries/Saskaita.class.php';
	$saskaitaObj = new Saskaita();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);

	if(!empty($removeId)) {
		$removeErrorParameter = '';
		
		// šaliname sąskaitų
		$saskaitaObj->deleteSaskaita($removeId);

		// nukreipiame į sąskaitų puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Sąskaitos</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Nauja sąskaita</a>
</div>
<div class="float-clear"></div>

<table>
	<tr>
		<th>Nr</th>
		<th>Suma</th>
		<th>Mokėjimo būdas</th>
		<th>Pirkėjo kodas</th>
		<th>Asistento tabelio nr.</th>
		<th></th>
	</tr>
	<?php
		// suskaičiuojame bendrą įrašų kiekį
		$elementCount = $saskaitaObj->getSaskaitaListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio automobilius
		$data = $saskaitaObj->getSaskaitaList($paging->size, $paging->first);

		// suformuojame lentelę
		foreach($data as $key => $val) {
			echo
				"<tr>"
					. "<td>{$val['nr']}</td>"
					. "<td>{$val['suma']}</td>"
					. "<td>{$val['budas']}</td>"
					. "<td>{$val['pirkejas']}</td>"
					. "<td>{$val['aptarnaujantisAsistentas']}</td>"
					. "<td>"
						. "<a href='#' onclick='showConfirmDialog(\"{$module}\", \"{$val['nr']}\"); return false;' title=''>šalinti</a>&nbsp;"
						. "<a href='index.php?module={$module}&id={$val['nr']}' title=''>redaguoti</a>"
					. "</td>"
				. "</tr>";
		}
	?>
</table>

<?php
	// įtraukiame puslapių šabloną
	include 'controls/paging.php';
?>