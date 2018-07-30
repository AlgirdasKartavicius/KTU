<?php

	// sukuriame mokėjimo būdų klasės objektą
	include 'libraries/MokejimoBudas.class.php';
	$mokejimoBudasObj = new MokejimoBudas();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);
	
	if(!empty($removeId)) {
		// patikriname, ar šalinamas mokėjimo būdas nepriskirtas sąskaitai
		$count = $mokejimoBudasObj->getSaskaitaCountOfMokejimoBudas($removeId);
		
		$removeErrorParameter = '';
		if($count == 0) {
			// šaliname mokėjimo būdą
			$mokejimoBudasObj->deleteMokejimoBudas($removeId);
		} else {
			// nepašalinome, nes mokėjimo būdas priskirtas sąskaitai, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}

		// nukreipiame į mokėjimo būdų puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Mokėjimo būdai</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Naujas mokėjimo būdas</a>
</div>
<div class="float-clear"></div>

<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
		Mokėjimo būdas nebuvo pašalintas. Pirmiausia pašalinkite sąskaitas su šiuo mokėjimo būdu.
	</div>
<?php } ?>

<table>
	<tr>
		<th>ID</th>
		<th>Pavadinimas</th>
		<th></th>
	</tr>
	<?php
		// suskaičiuojame bendrą įrašų kiekį
		$elementCount = $mokejimoBudasObj->getMokejimoBudasListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio mokėjimo būdus
		$data = $mokejimoBudasObj->getMokejimoBudasList($paging->size, $paging->first);

		// suformuojame lentelę
		foreach($data as $key => $val) {
			echo
				"<tr>"
					. "<td>{$val['id']}</td>"
					. "<td>{$val['name']}</td>"
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