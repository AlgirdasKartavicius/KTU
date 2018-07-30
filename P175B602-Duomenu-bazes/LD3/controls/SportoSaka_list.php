<?php

	// sukuriame sporto šakų klasės objektą
	include 'libraries/SportoSaka.class.php';
	$sportoSakaObj = new SportoSaka();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);
	
	if(!empty($removeId)) {
		// patikriname, ar šalinama sporto šaka nepriskirta sporto šakos įrankiui
		$count = $sportoSakaObj->getModelCountOfSportoSaka($removeId);
		
		$removeErrorParameter = '';
		if($count == 0) {
			// šaliname sporto šaką
			$sportoSakaObj->deleteSportoSaka($removeId);
		} else {
			// nepašalinome, nes sporto šaka priskirta sporto šakos įrankiui, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}

		// nukreipiame į būsenų puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Sporto šakos</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Nauja sporto šaka</a>
</div>
<div class="float-clear"></div>

<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
		Sporto šaka nebuvo pašalinta. Pirmiausia pašalinkite sporto šakos įrankius, priklausančius šiai sporto šakai.
	</div>
<?php } ?>

<table>
	<tr>
		<th>ID</th>
		<th>Pavadinimas</th>
		<th>Kilmės šalis</th>
		<th></th>
	</tr>
	<?php
		// suskaičiuojame bendrą įrašų kiekį
		$elementCount = $sportoSakaObj->getSportoSakaListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio būsenas
		$data = $sportoSakaObj->getSportoSakaList($paging->size, $paging->first);

		// suformuojame lentelę
		foreach($data as $key => $val) {
			echo
				"<tr>"
					. "<td>{$val['id']}</td>"
					. "<td>{$val['pavadinimas']}</td>"
					. "<td>{$val['kilmesSalis']}</td>"
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