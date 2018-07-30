<?php
	
	// sukuriame asistentų klasės objektą
	include 'libraries/AptarnaujantisAsistentas.class.php';
	$aptarnaujantisAsistentasObj = new AptarnaujantisAsistentas();

	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);

	if(!empty($removeId)) {
		// patikriname, ar asistentas nėra įtrauktas į sąskaitą
		$count = $aptarnaujantisAsistentasObj->getSaskaitaCountOfAptarnaujantisAsistentas($removeId);
		$countU = $aptarnaujantisAsistentasObj->getUzsakymaiCount($removeId);
		$countS = $aptarnaujantisAsistentasObj->getSiuntosCount($removeId);
		$removeErrorParameter = '';
		if($count == 0 && $countU == 0 && $countS == 0) {
			// šaliname asistentą
			$aptarnaujantisAsistentasObj->deleteAptarnaujantisAsistentas($removeId);
		} else {
			// nepašalinome, nes asistentas įtrauktas į sąskaitą, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}

		// nukreipiame į asistentų puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Aptarnaujantys asistentai</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Naujas aptarnaujantis asistentas</a>
</div>
<div class="float-clear"></div>

<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
		Aptarnaujantis asistentas nebuvo pašalintas, nes yra įtrauktas į sąskaitą (-as), užsakymą (-us) ar siuntą (-as).
	</div>
<?php } ?>

<table>
	<tr>
		<th>Tabelio nr.</th>
		<th>Vardas</th>
		<th>Pavardė</th>
		<th>Telefonas</th>
		<th></th>
	</tr>
	<?php
		// suskaičiuojame bendrą įrašų kiekį
		$elementCount = $aptarnaujantisAsistentasObj->getAptarnaujantisAsistentasListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio asistentus
		$data = $aptarnaujantisAsistentasObj->getAptarnaujantisAsistentasList($paging->size, $paging->first);

		// suformuojame lentelę
		foreach($data as $key => $val) {
			echo
				"<tr>"
					. "<td>{$val['tabelioNr']}</td>"
					. "<td>{$val['vardas']}</td>"
					. "<td>{$val['pavarde']}</td>"
					. "<td>{$val['telefonas']}</td>"
					. "<td>"
						. "<a href='#' onclick='showConfirmDialog(\"{$module}\", \"{$val['tabelioNr']}\"); return false;' title=''>šalinti</a>&nbsp;"
						. "<a href='index.php?module={$module}&id={$val['tabelioNr']}' title=''>redaguoti</a>"
					. "</td>"
				. "</tr>";
		}
	?>
</table>

<?php
	// įtraukiame puslapių šabloną
	include 'controls/paging.php';
?>