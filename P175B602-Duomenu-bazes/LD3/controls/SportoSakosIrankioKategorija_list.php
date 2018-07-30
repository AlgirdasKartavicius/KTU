<?php
	// sukuriame sporto šakos įrankių klasės objektą
	include 'libraries/SportoSakosIrankioKategorija.class.php';
	$modelsObj = new SportoSakosIrankioKategorija();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);
	
	if(!empty($removeId)) {
		// patikriname, ar šalinama sporto šakos įrankio kategorija nenaudojama, t.y. nepriskirtas jokiai prekei
		$count = $modelsObj->getPrekeCountOfSportoSakosIrankioKategorija($removeId);
		
		$removeErrorParameter = '';
		if($count == 0) {
			// pašaliname sporto šakos įrankio kategoriją
			$modelsObj->deleteSportoSakosIrankioKategorija($removeId);
		} else {
			// nepašalinome, nes sporto šakos įrankio kategorija priskirta bent vienai prekei, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}
		
		// nukreipiame į modelių puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Sporto šakos įrankių kategorijos </li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Nauja sporto šakos įrankio kategorija</a>
</div>
<div class="float-clear"></div>

<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
		Sporto šakos įrankio kategorija nebuvo pašalinta. Pirmiausia pašalinkite tos kategorijos prekes.
	</div>
<?php } ?>

<table>
	<tr>
		<th>Sporto šaka</th>
		<th>Kategorija</th>
		<th></th>
	</tr>
	<?php
		// suskaičiuojame bendrą įrašų kiekį
		$elementCount = $modelsObj->getSportoSakosIrankioKategorijaListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio kategorijas
		$data = $modelsObj->getSportoSakosIrankioKategorijaList($paging->size, $paging->first);

		// suformuojame lentelę
		foreach($data as $key => $val) {
			echo
				"<tr>"
					. "<td>{$val['SportoSaka']}</td>"
					. "<td>{$val['pavadinimas']}</td>"
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