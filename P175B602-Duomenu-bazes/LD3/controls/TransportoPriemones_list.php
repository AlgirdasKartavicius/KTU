<?php

	// sukuriame transporto priemonių klasės objektą
	include 'libraries/TransportoPriemones.class.php';
	$transportoPriemonesObj = new TransportoPriemones();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);
	
	if(!empty($removeId)) {
		// patikriname, ar šalinama transporto priemonė nepriskirta tarnybai
		$count = $transportoPriemonesObj->getTarnybaCountOfTransportoPriemones($removeId);
		
		$removeErrorParameter = '';
		if($count == 0) {
			// šaliname transporto priemonę
			$transportoPriemonesObj->deleteTransportoPriemones($removeId);
		} else {
			// nepašalinome, nes transporto priemonė priskirta tarnybai, rodome klaidos pranešimą
			$removeErrorParameter = 'remove_error=1';
		}

		// nukreipiame į transporto priemonių puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Transporto priemonės</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Nauja transporto priemonė</a>
</div>
<div class="float-clear"></div>

<?php if(isset($_GET['remove_error'])) { ?>
	<div class="errorBox">
		Transporto priemonė nebuvo pašalinta. Pirmiausia pašalinkite tarnybas su šia transporto priemone.
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
		$elementCount = $transportoPriemonesObj->getTransportoPriemonesListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio transporto priemones
		$data = $transportoPriemonesObj->getTransportoPriemonesList($paging->size, $paging->first);

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