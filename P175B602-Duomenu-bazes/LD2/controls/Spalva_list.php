<?php

	// sukuriame spalvų klasės objektą
	include 'libraries/Spalva.class.php';
	$spalvaObj = new Spalva();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);
	
	if(!empty($removeId)) {
		// patikriname, ar šalinama spalva nepriskirta prekei
		$count = $spalvaObj->getPrekeCountOfSpalva($removeId);
		
		$removeErrorParameter = '';
		if($count == 0) {
			// šaliname spalvą
			$spalvaObj->deleteSpalva($removeId);
		} else {
			// nepašalinome, nes spalva priskirta prekei, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}

		// nukreipiame į spalvų puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Spalvos</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Nauja spalva</a>
</div>
<div class="float-clear"></div>

<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
		Spalva nebuvo pašalinta. Pirmiausia pašalinkite prekes su šia spalva.
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
		$elementCount = $spalvaObj->getSpalvaListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio spalvas
		$data = $spalvaObj->getSpalvaList($paging->size, $paging->first);

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