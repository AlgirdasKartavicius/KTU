<?php

	// sukuriame pristato siuntą klasės objektą
	include 'libraries/PristatoSiunta.class.php';
	$pristatoSiuntaObj = new PristatoSiunta();
	
	// sukuriame puslapiavimo klasės objektą
	include 'utils/paging.class.php';
	$paging = new paging(NUMBER_OF_ROWS_IN_PAGE);

	if(!empty($removeId)) {
		$removeErrorParameter = '';
		
		// šaliname užsakymo prekę
		$pristatoSiuntaObj->deletePristatoSiunta($removeId);

		// nukreipiame į užsakymo prekių puslapį
		header("Location: index.php?module={$module}&{$removeErrorParameter}");
		die();
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li>Pristato siuntą</li>
</ul>
<div id="actions">
	<a href='index.php?module=<?php echo $module; ?>&action=new'>Naujas siuntos pristatymas</a>
</div>
<div class="float-clear"></div>

<table>
	<tr>
		<th>Tarnybos pavadinimas</th>
		<th>Pirkėjo kodas, kuriam pristatoma siunta</th>
		<th></th>
	</tr>
	<?php
		// suskaičiuojame bendrą įrašų kiekį
		$elementCount = $pristatoSiuntaObj->getPristatoSiuntaListCount();

		// suformuojame sąrašo puslapius
		$paging->process($elementCount, $pageId);

		// išrenkame nurodyto puslapio automobilius
		$data = $pristatoSiuntaObj->getPristatoSiuntaList($paging->size, $paging->first);

		// suformuojame lentelę
		foreach($data as $key => $val) {
			echo
				"<tr>"
					. "<td>{$val['tarnyba']}</td>"
					. "<td>{$val['pirkejas']}</td>"
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