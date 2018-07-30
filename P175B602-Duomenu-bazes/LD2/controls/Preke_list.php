<?php

	// sukuriame prekių klasės objektą
	include 'libraries/Preke.class.php';
	$prekeObj = new Preke();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);

	if(!empty($removeId)) {
		// patikriname, ar prekė neįtraukta į užsakymą
		$count = $prekeObj->getUzsakymoPrekeCountOfPreke($removeId);
	
		$removeErrorParameter = '';
		if($count == 0) {
			// šaliname prekę
			$prekeObj->deletePreke($removeId);
		} else {
			// nepašalinome, nes prekė įtraukta bent į vieną užsakymą, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}

		// nukreipiame į prekių puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Prekės</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Nauja prekė</a>
</div>
<div class="float-clear"></div>

<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
	Prekė nebuvo pašalinta, nes yra įtraukta į užsakymo prekę (-es).
	</div>
<?php } ?>

<table>
	<tr>
		<th>Kodas</th>
		<th>Pavadinimas</th>
		<th>Kaina</th>
		<th>Kategorija</th>
		<th>Būsena</th>
		<th></th>
	</tr>
	<?php
		// suskaičiuojame bendrą įrašų kiekį
		$elementCount = $prekeObj->getPrekeListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio automobilius
		$data = $prekeObj->getPrekeList($paging->size, $paging->first);

		// suformuojame lentelę
		foreach($data as $key => $val) {
			echo
				"<tr>"
					. "<td>{$val['kodas']}</td>"
					. "<td>{$val['pavadinimas']}</td>"
					. "<td>{$val['kaina']}</td>"
					. "<td>{$val['sportoSakosIrankioKategorija']}, {$val['sportoSaka']}</td>"
					. "<td>{$val['busena']}</td>"
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