<?php
	
	include 'libraries/AptarnaujantisAsistentas.class.php';
	$aptarnaujantisAsistentasObj = new AptarnaujantisAsistentas();

	$formErrors = null;
	$fields = array();
	
	// nustatome privalomus formos laukus
	$required = array('tabelioNr', 'vardas', 'pavarde', 'telefonas');
	
	// maksimalūs leidžiami laukų ilgiai
	$maxLengths = array (
		'tabelioNr' => 4,
		'vardas' => 20,
		'pavarde' => 20,
		'telefonas' => 12,
	);
	
	// vartotojas paspaudė išsaugojimo mygtuką
	if(!empty($_POST['submit'])) {
		include 'utils/validator.class.php';
		
		// nustatome laukų validatorių tipus
		$validations = array (
			'tabelioNr' => 'alfanum',
			'vardas' => 'words',
			'pavarde' => 'words',
			'telefonas' => 'phone',
			'el_pastas' => 'email');
		
		// sukuriame laukų validatoriaus objektą
		$validator = new validator($validations, $required, $maxLengths);

		// laukai įvesti be klaidų
		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();

			if(isset($data['editing'])) {
				// redaguojame asistentą
				$aptarnaujantisAsistentasObj->updateAptarnaujantisAsistentas($data);
			} else {
				$tmp = $aptarnaujantisAsistentasObj->getAptarnaujantisAsistentas($data['tabelioNr']);
				
				if(isset($tmp['tabelioNr'])){
					// sudarome klaidų pranešimą
					$formErrors = "Asistentas su įvestu tabelio numeriu jau egzistuoja.";
					// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
					$fields = $_POST;
				} else{
				
				// įrašome naują asistentą
					$aptarnaujantisAsistentasObj->insertAptarnaujantisAsistentas($data);
				}
			}

			// nukreipiame vartotoją į asistentų puslapį
			if($formErrors == null) {
				header("Location: index.php?module={$module}");
				die();
			}
		} else {
			// gauname klaidų pranešimą
			$formErrors = $validator->getErrorHTML();
			
			// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
			$fields = $_POST;
		}
	} else {
		// tikriname, ar nurodytas elemento id. Jeigu taip, išrenkame elemento duomenis ir jais užpildome formos laukus.
		if(!empty($id)) {
			// išrenkame klientą
			$fields = $aptarnaujantisAsistentasObj->getAptarnaujantisAsistentas($id);
			$fields['editing'] = 1;
		}
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li><a href="index.php?module=<?php echo $module; ?>">Aptarnaujantys asistentai</a></li>
	<li><?php if(!empty($id)) echo "Aptarnaujančio asistento redagavimas"; else echo "Naujas aptarnaujantis asistentas"; ?></li>
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
			<legend>Aptarnaujančio asistento informacija</legend>
				<p>
					<label class="field" for="tabelioNr">Tabelio numeris<?php echo in_array('tabelioNr', $required) ? '<span> *</span>' : ''; ?></label>
					<?php if(!isset($fields['editing'])) { ?>
						<input type="text" id="tabelioNr" name="tabelioNr" class="textbox-150" value="<?php echo isset($fields['tabelioNr']) ? $fields['tabelioNr'] : ''; ?>" />
						<?php if(key_exists('tabelioNr', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['tabelioNr']} simb.)</span>"; ?>
					<?php } else { ?>
						<span class="input-value"><?php echo $fields['tabelioNr']; ?></span>
						<input type="hidden" name="editing" value="1" />
						<input type="hidden" name="tabelioNr" value="<?php echo $fields['tabelioNr']; ?>" />
					<?php } ?>
				</p>
			<p>
				<label class="field" for="vardas">Vardas<?php echo in_array('vardas', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="vardas" name="vardas" class="textbox-150" value="<?php echo isset($fields['vardas']) ? $fields['vardas'] : ''; ?>" />
				<?php if(key_exists('vardas', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['vardas']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="pavarde">Pavardė<?php echo in_array('pavarde', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="pavarde" name="pavarde" class="textbox-150" value="<?php echo isset($fields['pavarde']) ? $fields['pavarde'] : ''; ?>" />
				<?php if(key_exists('pavarde', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['pavarde']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="telefonas">Telefonas<?php echo in_array('telefonas', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="telefonas" name="telefonas" class="textbox-150" value="<?php echo isset($fields['telefonas']) ? $fields['telefonas'] : ''; ?>" />
				<?php if(key_exists('telefonas', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['telefonas']} simb.)</span>"; ?>
			</p>
			<p>
				<label class="field" for="el_pastas">El. Paštas<?php echo in_array('el_pastas', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="el_pastas" name="el_pastas" class="textbox-150" value="<?php echo isset($fields['el_pastas']) ? $fields['el_pastas'] : ''; ?>" />
			</p>
		</fieldset>
		<p class="required-note">* pažymėtus laukus užpildyti privaloma</p>
		<p>
			<input type="submit" class="submit" name="submit" value="Išsaugoti">
		</p>
	</form>
</div>