<?php

	// sukuriame pristatymo būdų klasės objektą
	include 'libraries/PristatymoBudas.class.php';
	$pristatymoBudas = new PristatymoBudas();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);
	
	if(!empty($removeId)) {
		// patikriname, ar šalinamas pristatymo būdas nepriskirtas užsakymui
		$count = $pristatymoBudas->getUzsakymasCountOfPristatymoBudas($removeId);
		
		$removeErrorParameter = '';
		if($count == 0) {
			// šaliname pristatymo būdą
			$pristatymoBudas->deletePristatymoBudas($removeId);
		} else {
			// nepašalinome, nes pristatymo būdas priskirtas užsakymui, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}

		// nukreipiame į pristatymo būdų puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Pristatymo būdai</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Naujas pristatymo būdas</a>
</div>
<div class="float-clear"></div>

<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
		Pristatymo būdas nebuvo pašalintas. Pirmiausia pašalinkite užsakymus su šiuo pristatymo būdu.
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
		$elementCount = $pristatymoBudas->getPristatymoBudasListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio sezonus
		$data = $pristatymoBudas->getPristatymoBudasList($paging->size, $paging->first);

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