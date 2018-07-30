<?php

	include 'libraries/PristatoSiunta.class.php';
	$pristatoSiuntaObj = new PristatoSiunta();
	
	$formErrors = null;
	$fields = array();

	// nustatome privalomus laukus
	$required = array('fk_SiuntuPervezimoTarnybaid', 'fk_Pirkejaskodas');
	
	// maksimalūs leidžiami laukų ilgiai
	$maxLengths = array (
	);
	
	// vartotojas paspaudė išsaugojimo mygtuką
	if(!empty($_POST['submit'])) {
		// sukuriame laukų validatoriaus objektą
		include 'utils/validator.class.php';
		// nustatome laukų validatorių tipus
		$validations = array (
			'fk_SiuntuPervezimoTarnybaid' => 'positivenumber',
			'fk_Pirkejaskodas' => 'alfanum');
				
		
		$validator = new validator($validations, $required, $maxLengths);

		// laukai įvesti be klaidų
		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();
			
			if(isset($data['id'])) {
				// atnaujiname duomenis
				$pristatoSiuntaObj->updatePristatoSiunta($data);
			} else {
				// įrašome naują pristato siuntą
				$latestId = $pristatoSiuntaObj->getMaxIdOfPristatoSiunta();
				
				// įrašome naują įrašą
				$data['id'] = $latestId + 1;
				$pristatoSiuntaObj->insertPristatoSiunta($data);
			}
			
			// nukreipiame vartotoją į siuntų puslapį
			header("Location: index.php?module={$module}");
			die();
		} else {
			// gauname klaidų pranešimą
			$formErrors = $validator->getErrorHTML();
			// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
			$fields = $_POST;
		}
	} else {
		// tikriname, ar nurodytas elemento id. Jeigu taip, išrenkame elemento duomenis ir jais užpildome formos laukus.
		if(!empty($id)) {
			// išrenkame prekę
			$fields = $pristatoSiuntaObj->getPristatoSiunta($id);
			$fields['editing'] = 1;
		}
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li><a href="index.php?module=<?php echo $module; ?>">Pristato siuntą</a></li>
	<li><?php if(!empty($id)) echo "Pristato siuntą redagavimas"; else echo "Naujas siuntos pristatymas"; ?></li>
</ul>
<div class="float-clear"></div>
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
			<legend>Pristato siuntą informacija</legend>
			<p>
				<label class="field" for="fk_SiuntuPervezimoTarnybaid">Tarnybos pavadinimas<?php echo in_array('fk_SiuntuPervezimoTarnybaid', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="fk_SiuntuPervezimoTarnybaid" name="fk_SiuntuPervezimoTarnybaid">
					<option value="-1">Pasirinkite tarnybą</option>
					<?php
						// išrenkame visas tarnybas
						$tarnybos = $pristatoSiuntaObj->getSiuntuPervezimoTarnybaList();
						foreach($tarnybos as $key => $val) {
							$selected = "";
							if(isset($fields['fk_SiuntuPervezimoTarnybaid']) && $fields['fk_SiuntuPervezimoTarnybaid'] == $val['id']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['id']}'>{$val['pavadinimas']}</option>";
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="fk_Pirkejaskodas">Pirkėjo, kuriam pristatoma siunta, kodas<?php echo in_array('fk_Pirkejaskodas', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="fk_Pirkejaskodas" name="fk_Pirkejaskodas">
					<option value="-1">Pasirinkite pirkėją</option>
					<?php
						// išrenkame visus pirkėjus
						$pirkejai = $pristatoSiuntaObj->getPirkejasList();
						foreach($pirkejai as $key => $val) {
							$selected = "";
							if(isset($fields['fk_Pirkejaskodas']) && $fields['fk_Pirkejaskodas'] == $val['kodas']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['kodas']}'>{$val['kodas']}</option>";
						}
					?>
				</select>
			</p>
		</fieldset>
		<p class="required-note">* pažymėtus laukus užpildyti privaloma</p>
		<p>
			<input type="submit" class="submit" name="submit" value="Išsaugoti">
		</p>
		<?php if(isset($fields['id'])) { ?>
			<input type="hidden" name="id" value="<?php echo $fields['id']; ?>" />
		<?php } ?>
	</form>
</div>