<?php

	// sukuriame spalvų klasės objektą
	include 'libraries/Sezonas.class.php';
	$sezonasObj = new Sezonas();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);
	
	if(!empty($removeId)) {
		// patikriname, ar šalinamas sezonas nepriskirtas prekei
		$count = $sezonasObj->getPrekeCountOfSezonas($removeId);
		
		$removeErrorParameter = '';
		if($count == 0) {
			// šaliname sezoną
			$sezonasObj->deleteSezonas($removeId);
		} else {
			// nepašalinome, nes sezonas priskirtas prekei, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}

		// nukreipiame į sezonų puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Sezonai</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Naujas sezonas</a>
</div>
<div class="float-clear"></div>

<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
		Sezonas nebuvo pašalintas. Pirmiausia pašalinkite prekes su šiuo sezonu.
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
		$elementCount = $sezonasObj->getSezonasListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio sezonus
		$data = $sezonasObj->getSezonasList($paging->size, $paging->first);

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