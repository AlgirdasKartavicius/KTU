<?php

	// sukuriame užsakymų klasės objektą
	include 'libraries/Uzsakymas.class.php';
	$UzsakymasObj = new Uzsakymas();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);

	if(!empty($removeId)) {
		$count = $UzsakymasObj->getSaskaitaCountOfAptarnaujantisAsistentas($removeId);
		$countS = $UzsakymasObj->getSiuntosCount($removeId);
		$removeErrorParameter = '';
		
		if($count == 0 && $countS == 0) {
			// šaliname užsakymą
			$UzsakymasObj->deleteUzsakymas($removeId);
		} else {
			// nepašalinome, nes asistentas įtrauktas į sąskaitą, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}
		

		// nukreipiame į užsakymų puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Užsakymai</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Naujas užsakymas</a>
</div>
<div class="float-clear"></div>


<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
		Užsakymas nebuvo pašalintas, nes turi jam priklausančių užsakymo prekių arba siuntų.
	</div>
<?php } ?>

<table>
	<tr>
		<th>Užsakymo numeris</th>
		<th>Pirkėjo kodas</th>
		<th>Asistento tabelio nr.</th>
		<th>Pristatymo būdas</th>
		<th></th>
	</tr>
	<?php
		// suskaičiuojame bendrą įrašų kiekį
		$elementCount = $UzsakymasObj->getUzsakymasListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio automobilius
		$data = $UzsakymasObj->getUzsakymasList($paging->size, $paging->first);

		// suformuojame lentelę
		foreach($data as $key => $val) {
			echo
				"<tr>"
					. "<td>{$val['uzsakymoNumeris']}</td>"
					. "<td>{$val['pirkejas']}</td>"
					. "<td>{$val['aptarnaujantisAsistentas']}</td>"
					. "<td>{$val['pristatymoBudas']}</td>"
					. "<td>"
						. "<a href='#' onclick='showConfirmDialog(\"{$module}\", \"{$val['uzsakymoNumeris']}\"); return false;' title=''>šalinti</a>&nbsp;"
						. "<a href='index.php?module={$module}&id={$val['uzsakymoNumeris']}' title=''>redaguoti</a>"
					. "</td>"
				. "</tr>";
		}
	?>
</table>

<?php
	// įtraukiame puslapių šabloną
	include 'controls/paging.php';
?>