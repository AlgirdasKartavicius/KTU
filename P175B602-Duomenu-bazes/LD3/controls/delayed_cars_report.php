<?php

	include 'libraries/contracts.class.php';
	$contractsObj = new contracts();
	
	include 'libraries/SportoSaka.class.php';
	$sportoSakaObj = new SportoSaka();
	
	$formErrors = null;
	$fields = array();
	$formSubmitted = false;
		
	$data = array();
	if(!empty($_POST['submit'])) {
		$formSubmitted = true;

		// nustatome laukų validatorių tipus
		$validations = array (
			'fk_SportoSakaid' => 'positivenumber');
		
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
			<li class="title">Sporto šakos prekių ataskaita</li>
			<li>Sudarymo data: <span><?php echo date("Y-m-d"); ?></span></li>
			<li>Sporto šaka: <span><?php echo "{$sportoSakaObj->getSportoSaka($data['fk_SportoSakaid'])['pavadinimas']}"; ?></span></li>
			<li><a href="report.php?id=3" title="Nauja ataskaita" class="newReport">nauja ataskaita</a></li>	
		</ul>
	</div>
<?php } ?>
<div id="content">
	<div id="contentMain">
		<?php
			if($formSubmitted == false || $formErrors != null) { ?>
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
							<legend>Pasirinkite ataskaitos kriterijus</legend>
							<p>
								<label class="field" for="dataNuo">Sporto šaka</label>
								<select id="SportoSaka" name="fk_SportoSakaid">
									<option value="-1">Pasirinkite sporto šaką</option>
									<?php
										// išrenkame visas sporto šakas
										$sportoSakos = $sportoSakaObj->getSportoSakaList();
										foreach($sportoSakos as $key => $val) {
											$selected = "";
											if(isset($fields['fk_SportoSakaid']) && $fields['fk_SportoSakaid'] == $val['id']) {
												$selected = " selected='selected'";
											}
											echo "<option{$selected} value='{$val['id']}'>{$val['pavadinimas']}</option>";
										}
									?>
								</select>
							</p>
						</fieldset>
						<p><input type="submit" class="submit" name="submit" value="Sudaryti ataskaitą"></p>
					</form>
				</div>
	<?php	} else {
					// išrenkame ataskaitos duomenis
				$contractData = $contractsObj->getSportoSakosPrekes($data['fk_SportoSakaid']);
				
				if(sizeof($contractData) > 0) { ?>
		
					<table class="reportTable">
						<tr>
							<th>Prekės kodas</th>
							<th>Pavadinimas</th>
							<th>Kaina</th>
						</tr>

						<?php

							// suformuojame lentelę
							for($i = 0; $i < sizeof($contractData); $i++) {
								
								if($i == 0 || $contractData[$i]['kategorija'] != $contractData[$i-1]['kategorija']) {
									echo
										"<tr class='rowSeparator'><td colspan='5'></td></tr>"
										. "<tr>"
											. "<td class='groupSeparator' colspan='4'>{$contractData[$i]['kategorija']}</td>"
										. "</tr>";
								}
								
								echo
									"<tr>"
										. "<td>#{$contractData[$i]['kodas']}</td>"
										. "<td>{$contractData[$i]['prekes_pavadinimas']}</td>"
										. "<td>{$contractData[$i]['prekes_kaina']} &euro;</td>"
									. "</tr>";
								if($i == (sizeof($contractData) - 1) || $contractData[$i]['kategorija'] != $contractData[$i+1]['kategorija']) {
									$sum = $contractsObj->getSportoSakosKategorijosPrekiuSum($data['fk_SportoSakaid'], $contractData[$i]['kategorija']);
									echo 
										"<tr class='aggregate'>"
											. "<td colspan='2'></td>"
											. "<td class='border'>{$sum} &euro;</td>"
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
							<td class="label" colspan="2">Suma:</td>
							<td class="border"><?php echo $contractsObj->getTotalSumOfPrekes($data['fk_SportoSakaid']); ?> &euro;</td>
						</tr>
						
					</table>

			<?php   } else { ?>
						<div class="warningBox">
							Tokios sporto šakos prekių nėra
						</div>
					<?php
					}
			}
			?>
	</div>
</div>