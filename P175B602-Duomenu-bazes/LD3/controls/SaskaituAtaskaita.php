<?php

	include 'libraries/contracts.class.php';
	$contractsObj = new contracts();
	
	$formErrors = null;
	$fields = array();
	$formSubmitted = false;
		
	$data = array();
	if(!empty($_POST['submit'])) {
		$formSubmitted = true;

		// nustatome laukų validatorių tipus
		$validations = array (
			'dataNuo' => 'date',
			'dataIki' => 'date');
		
		// sukuriame validatoriaus objektą
		include 'utils/validator.class.php';
		$validator = new validator($validations);
		

		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();
		} else {
			// gauname klaidų pranešimą
			$formErrors = $validator->getErrorHTML();
			// gauname įvestus laukus
			$fields = $_POST;
		}
	}
	
if($formSubmitted == true && ($formErrors == null)) { ?>
	<div id="header">
		<ul id="reportInfo">
			<li class="title">Sudarytų sąskaitų ataskaita</li>
			<li>Sudarymo data: <span><?php echo date("Y-m-d"); ?></span></li>
			<li>Sąskaitų sudarymo laikotarpis:
				<span>
					<?php
						if(!empty($data['dataNuo'])) {
							if(!empty($data['dataIki'])) {
								echo "nuo {$data['dataNuo']} iki {$data['dataIki']}";
							} else {
								echo "nuo {$data['dataNuo']}";
							}
						} else {
							if(!empty($data['dataIki'])) {
								echo "iki {$data['dataIki']}";
							} else {
								echo "nenurodyta";
							}
						}
					?>
				</span>
			</li>
			<li><a href="report.php?id=1" title="Nauja ataskaita" class="newReport">nauja ataskaita</a></li>
		</ul>
	</div>
<?php } ?>
<div id="content">
	<div id="contentMain">
		<?php if($formSubmitted == false || $formErrors != null) { ?>
			<div id="formContainer">
				<?php if($formErrors != null) { ?>
					<div class="errorBox">
						Neįvesti arba neteisingai įvesti šie laukai:
						<?php 
							echo $formErrors;
						?>
					</div>
				<?php } ?>
				<form action="" method="post">
					<fieldset>
						<legend>Įveskite ataskaitos kriterijus</legend>
						<p><label class="field" for="dataNuo">Sąskaitos sudarytos nuo</label><input type="text" id="dataNuo" name="dataNuo" class="textbox-100 date" value="<?php echo isset($fields['dataNuo']) ? $fields['dataNuo'] : ''; ?>" /></p>
						<p><label class="field" for="dataIki">Sąskaitos sudarytos iki</label><input type="text" id="dataIki" name="dataIki" class="textbox-100 date" value="<?php echo isset($fields['dataIki']) ? $fields['dataIki'] : ''; ?>" /></p>
					</fieldset>
					<p><input type="submit" class="submit" name="submit" value="Sudaryti ataskaitą"></p>
				</form>
			</div>
		<?php } else {
			
				// išrenkame ataskaitos duomenis
				$contractData = $contractsObj->getCustomerOrders($data['dataNuo'], $data['dataIki']);
				$totalPrice = $contractsObj->getSumPriceOfOrders($data['dataNuo'], $data['dataIki']);
				$totalCount = $contractsObj->getCountOfOrders($data['dataNuo'], $data['dataIki']);
				
				if(sizeof($contractData) > 0) { ?>
		
					<table class="reportTable">
						<tr>
							<th>Sąskaita</th>
							<th>Sąskaitos sudarytojo tabelio numeris</th>
							<th>Data</th>
							<th>Suma</th>
							<th>Saskaitų kiekis</th>
						</tr>

						<?php

							// suformuojame lentelę
							for($i = 0; $i < sizeof($contractData); $i++) {
								
								if($i == 0 || $contractData[$i]['kodas'] != $contractData[$i-1]['kodas']) {
									echo
										"<tr class='rowSeparator'><td colspan='5'></td></tr>"
										. "<tr>"
											. "<td class='groupSeparator' colspan='5'>{$contractData[$i]['vardas']} {$contractData[$i]['pavarde']}</td>"
										. "</tr>";
								}
								
								echo
									"<tr>"
										. "<td>#{$contractData[$i]['nr']}</td>"
										. "<td>#{$contractData[$i]['tabelioNr']}</td>"
										. "<td>{$contractData[$i]['data']}</td>"
										. "<td>{$contractData[$i]['saskaitos_kaina']} &euro;</td>"
										. "<td> </td>"
									. "</tr>";
								if($i == (sizeof($contractData) - 1) || $contractData[$i]['kodas'] != $contractData[$i+1]['kodas']) {

									if($contractData[$i]['bendra_kliento_saskaitu_suma'] == 0) {
										$contractData[$i]['bendra_kliento_saskaitu_suma'] = "neužsakyta";
									} else {
										$contractData[$i]['bendra_kliento_saskaitu_suma'] .= " &euro;";
									}
									
									
									echo 
										"<tr class='aggregate'>"
											. "<td colspan='3'></td>"
											. "<td class='border'>{$contractData[$i]['bendra_kliento_saskaitu_suma']}</td>"
											. "<td class='border'>{$contractData[$i]['bendras_kliento_saskaitu_skaicius']}</td>"
										. "</tr>";
								}
							}
						?>
						
						<tr class="rowSeparator">
							<td colspan="5"></td>
						</tr>
						
						<tr class="rowSeparator">
							<td colspan="5"></td>
						</tr>
						
						<tr class="aggregate">
							<td class="label" colspan="3">Suma:</td>
							<td class="border"><?php echo $totalPrice[0]['saskaitos_suma']; ?> &euro;</td>
							<td class="border"><?php echo $totalCount[0]['saskaitu_kiekis']; ?></td>
						</tr>
					</table>
			<?php   } else { ?>
						<div class="warningBox">
							Nurodytu laikotartpiu sutarčių nebuvo užsakyta
						</div>
					<?php
					}
			} ?>
	</div>
</div>