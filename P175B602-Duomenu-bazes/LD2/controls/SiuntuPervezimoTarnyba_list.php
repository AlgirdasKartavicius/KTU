<?php
	// sukuriame siuntų pervežimo tarnybų klasės objektą
	include 'libraries/SiuntuPervezimoTarnyba.class.php';
	$siuntuPervezimoTarnybaObj = new SiuntuPervezimoTarnyba();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);
	
	if(!empty($removeId)) {
		// patikriname, ar šalinama siuntų pervežimo tarnyba nenaudojama
		$count = $siuntuPervezimoTarnybaObj->getSiuntaCountOfSiuntuPervezimoTarnyba($removeId);
		
		$removeErrorParameter = '';
		if($count == 0) {
			// pašaliname tarnybą
			$siuntuPervezimoTarnybaObj->deleteSiuntuPervezimoTarnyba($removeId);
		} else {
			// nepašalinome, nes tarnybą priskirta bent vienai siuntai, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}
		
		// nukreipiame į tarnybų puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Siuntų pervežimo tarnybos</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Nauja siuntų pervežimo tarnyba</a>
</div>
<div class="float-clear"></div>

<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
		Siuntų pervežimo tarnyba nebuvo pašalinta. Pirmiausia pašalinkite tos tarnybos siuntas.
	</div>
<?php } ?>

<table>
	<tr>
		<th>ID</th>
		<th>Pavadinimas</th>
		<th>Transporto priemonių kiekis</th>
		<th>Transporto priemonė</th>
		<th></th>
	</tr>
	<?php
		// suskaičiuojame bendrą įrašų kiekį
		$elementCount = $siuntuPervezimoTarnybaObj->getSiuntuPervezimoTarnybaListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio kategorijas
		$data = $siuntuPervezimoTarnybaObj->getSiuntuPervezimoTarnybaList($paging->size, $paging->first);

		// suformuojame lentelę
		foreach($data as $key => $val) {
			echo
				"<tr>"
					. "<td>{$val['id']}</td>"
					. "<td>{$val['pavadinimas']}</td>"
					. "<td>{$val['transportoPriemoniuKiekis']}</td>"
					. "<td>{$val['transportoPriemones']}</td>"
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