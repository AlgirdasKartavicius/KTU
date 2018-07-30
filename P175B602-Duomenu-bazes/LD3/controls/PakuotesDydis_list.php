<?php

	// sukuriame pakuotės dydžių klasės objektą
	include 'libraries/PakuotesDydis.class.php';
	$pakuotesDydisObj = new PakuotesDydis();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);
	
	if(!empty($removeId)) {
		// patikriname, ar šalinamas pakuotės dydis nepriskirtas siuntai
		$count = $pakuotesDydisObj->getSiuntaCountOfPakuotesDydis($removeId);
		
		$removeErrorParameter = '';
		if($count == 0) {
			// šaliname pakuotės dydį
			$pakuotesDydisObj->deletePakuotesDydis($removeId);
		} else {
			// nepašalinome, nes pakuotės dydis priskirtas užsakymui, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}

		// nukreipiame į pakuotės dydžių puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Pakuotės dydžiai</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Naujas pakuotės dydis</a>
</div>
<div class="float-clear"></div>

<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
		Pakuotės dydis nebuvo pašalintas. Pirmiausia pašalinkite siuntas su šiuo pakuotės dydžiu.
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
		$elementCount = $pakuotesDydisObj->getPakuotesDydisListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio sezonus
		$data = $pakuotesDydisObj->getPakuotesDydisList($paging->size, $paging->first);

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