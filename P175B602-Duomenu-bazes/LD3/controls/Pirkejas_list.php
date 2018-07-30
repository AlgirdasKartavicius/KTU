<?php
	
	// sukuriame pirkėjų klasės objektą
	include 'libraries/Pirkejas.class.php';
	$pirkejasObj = new Pirkejas();

	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);

	if(!empty($removeId)) {
		// patikriname, ar pirkėjas nėra įtrauktas į užsakymą
		$count = $pirkejasObj->getUzsakymasCountOfPirkejas($removeId);
		$countS = $pirkejasObj->getSiuntosCount($removeId);
		$countSa = $pirkejasObj->getSaskaitosCount($removeId);
		$countP = $pirkejasObj->getPristatoSiuntaCount($removeId);
		
		$removeErrorParameter = '';
		if($count == 0 && $countS == 0 && $countSa == 0 && $countP == 0) {
			// šaliname pirkėją
			$pirkejasObj->deletePirkejas($removeId);
		} else {
			// nepašalinome, nes pirkėjas įtrauktas į užsakymą, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}

		// nukreipiame į pirkėjų puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Pirkėjai</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Naujas pirkėjas</a>
</div>
<div class="float-clear"></div>

<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
		Pirkėjas nebuvo pašalintas, nes yra įtrauktas į užsakymą (-us), sąskaitą (-as), siuntą (-as) ar pristato siuntą (-as).
	</div>
<?php } ?>

<table>
	<tr>
		<th>Kodas</th>
		<th>Prisijungimo vardas</th>
		<th>Vardas</th>
		<th>Pavardė</th>
		<th>Telefonas</th>
		<th></th>
	</tr>
	<?php
		// suskaičiuojame bendrą įrašų kiekį
		$elementCount = $pirkejasObj->getPirkejasListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio pirkėjus
		$data = $pirkejasObj->getPirkejasList($paging->size, $paging->first);

		// suformuojame lentelę
		foreach($data as $key => $val) {
			echo
				"<tr>"
					. "<td>{$val['kodas']}</td>"
					. "<td>{$val['prisijungimoVardas']}</td>"
					. "<td>{$val['vardas']}</td>"
					. "<td>{$val['pavarde']}</td>"
					. "<td>{$val['telefonas']}</td>"
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