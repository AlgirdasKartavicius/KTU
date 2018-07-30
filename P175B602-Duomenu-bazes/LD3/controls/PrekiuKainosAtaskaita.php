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
			'kaina' => 'price');
		
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
			<li class="title">Prekių, pigesnių už nurodytą kainą, ataskaita</li>
			<li>Sudarymo data: <span><?php echo date("Y-m-d"); ?></span></li>
			<li>Nurodyta prekės kaina:
				<span>
					<?php
						if(!empty($data['kaina'])) {
							echo " iki {$data['kaina']} &euro; ";
						}
						else{
							echo " nenurodyta";
						}
					?>
				</span>
			</li>
			<li><a href="report.php?id=2" title="Nauja ataskaita" class="newReport">nauja ataskaita</a></li>
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
							<legend>Įveskite ataskaitos kriterijus</legend>
							<p><label class="field" for="dataNuo">Prekių kaina iki: </label><input type="text" id="kaina" name="kaina" class="textbox-100" value="<?php echo isset($fields['kaina']) ? $fields['kaina'] : ''; ?>" /></p>
						</fieldset>
						<p><input type="submit" class="submit" name="submit" value="Sudaryti ataskaitą"></p>
					</form>
				</div>
	<?php	} else {
					// išrenkame ataskaitos duomenis
					$prekes = $contractsObj->getPrekesPriceLowerThan($data['kaina']);
					if(sizeof($prekes) > 0) { ?>
						<table class="reportTable">
							<tr>
								<th>Prekės kodas</th>
								<th>Pavadinimas</th>
								<th>Kategorija</th>
								<th>Kaina</th>
							</tr>

							<tr>
								<td class="separator" colspan="5"></td>
							</tr>

							<?php
								// suformuojame lentelę
								foreach($prekes as $key => $val) {
									echo
										"<tr>"
											. "<td>#{$val['kodas']}</td>"
											. "<td>{$val['pavadinimas']}</td>"
											. "<td>{$val['kategorija']}</td>"
											. "<td>{$val['kaina']}</td>"
										. "</tr>";
								}
							?>
						</table>

			<?php   } else { ?>
						<div class="warningBox">
							Nėra prekių už mažesnę kainą nei nurodyta
						</div>
					<?php
					}
			}
			?>
	</div>
</div>