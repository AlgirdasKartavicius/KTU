<?php

	include 'libraries/UzsakymoPreke.class.php';
	$uzsakymoPrekeObj = new UzsakymoPreke();
	
	$formErrors = null;
	$fields = array();

	// nustatome privalomus laukus
	$required = array('kiekis', 'fk_UzsakymasuzsakymoNumeris', 'fk_Prekekodas');
	
	// maksimalūs leidžiami laukų ilgiai
	$maxLengths = array (
		'kiekis' => 2
	);
	
	// vartotojas paspaudė išsaugojimo mygtuką
	if(!empty($_POST['submit'])) {
		// sukuriame laukų validatoriaus objektą
		include 'utils/validator.class.php';
		// nustatome laukų validatorių tipus
		$validations = array (
			'kiekis' => 'int',
			'fk_Prekekodas' => 'alfanum',
			'fk_UzsakymasuzsakymoNumeris' => 'alfanum');
				
		
		$validator = new validator($validations, $required, $maxLengths);

		// laukai įvesti be klaidų
		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();
			
			if(isset($data['id'])) {
				// atnaujiname duomenis
				$uzsakymoPrekeObj->updateUzsakymoPreke($data);
			} else {
				// įrašome naują užsakymo prekę
				$latestId = $uzsakymoPrekeObj->getMaxIdOfUzsakymoPreke();
				
				// įrašome naują įrašą
				$data['id'] = $latestId + 1;
				$uzsakymoPrekeObj->insertUzsakymoPreke($data);
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
			$fields = $uzsakymoPrekeObj->getUzsakymoPreke($id);
			$fields['editing'] = 1;
		}
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li><a href="index.php?module=<?php echo $module; ?>">Užsakymo prekės</a></li>
	<li><?php if(!empty($id)) echo "Užsakymo prekės redagavimas"; else echo "Nauja užsakymo prekė"; ?></li>
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
			<legend>Užsakymo prekės informacija</legend>
			<p>
				<label class="field" for="kiekis">Kiekis<?php echo in_array('kiekis', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="kiekis" name="kiekis" class="textbox-70" value="<?php echo isset($fields['kiekis']) ? $fields['kiekis'] : ''; ?>">
			</p>
			<p>
				<label class="field" for="fk_UzsakymasuzsakymoNumeris">Užsakymo numeris<?php echo in_array('fk_UzsakymasuzsakymoNumeris', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="fk_UzsakymasuzsakymoNumeris" name="fk_UzsakymasuzsakymoNumeris">
					<option value="-1">Pasirinkite užsakymą</option>
					<?php
						// išrenkame visus užsakymus
						$uzsakymai = $uzsakymoPrekeObj->getUzsakymasList();
						foreach($uzsakymai as $key => $val) {
							$selected = "";
							if(isset($fields['fk_UzsakymasuzsakymoNumeris']) && $fields['fk_UzsakymasuzsakymoNumeris'] == $val['uzsakymoNumeris']) {
								$selected = " selected='selected'";
							}
							echo "<option{$selected} value='{$val['uzsakymoNumeris']}'>{$val['uzsakymoNumeris']}</option>";
						}
					?>
				</select>
			</p>
			<p>
				<label class="field" for="fk_Prekekodas">Prekės kodas<?php echo in_array('fk_Prekekodas', $required) ? '<span> *</span>' : ''; ?></label>
				<select id="fk_Prekekodas" name="fk_Prekekodas">
					<option value="-1">Pasirinkite prekę</option>
					<?php
						// išrenkame visas prekes
						$prekes = $uzsakymoPrekeObj->getPrekeList();
						foreach($prekes as $key => $val) {
							$selected = "";
							if(isset($fields['fk_Prekekodas']) && $fields['fk_Prekekodas'] == $val['kodas']) {
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