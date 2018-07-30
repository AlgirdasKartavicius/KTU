<?php
	
	include 'libraries/Pirkejas.class.php';
	$pirkejasObj = new Pirkejas();

	$formErrors = null;
	$fields = array();
	
	// nustatome privalomus formos laukus
	$required = array('kodas', 'prisijungimoVardas', 'slaptazodis', 'vardas', 'pavarde', 'telefonas');
	
	// maksimalūs leidžiami laukų ilgiai
	$maxLengths = array (
		'kodas' => 8,
		'prisijungimoVardas' => 20,
		'slaptazodis' => 20,
		'vardas' => 20,
		'pavarde' => 20,
		'telefonas' => 12,
	);
	
	// vartotojas paspaudė išsaugojimo mygtuką
	if(!empty($_POST['submit'])) {
		include 'utils/validator.class.php';
		
		// nustatome laukų validatorių tipus
		$validations = array (
			'kodas' => 'alfanum',
			'prisijungimoVardas' => 'alfanum',
			'slaptazodis' => 'alfanum',
			'vardas' => 'words',
			'pavarde' => 'words',
			'telefonas' => 'phone',
			'el_pastas' => 'email',
			'adresas' => 'alfanum');
		
		// sukuriame laukų validatoriaus objektą
		$validator = new validator($validations, $required, $maxLengths);

		// laukai įvesti be klaidų
		if($validator->validate($_POST)) {
			// suformuojame laukų reikšmių masyvą SQL užklausai
			$data = $validator->preparePostFieldsForSQL();

			if(isset($data['editing'])) {
				// redaguojame pirkėją
				$pirkejasObj->updatePirkejas($data);
			} else {
				$tmp = $pirkejasObj->getPirkejas($data['kodas']);
				if(isset($tmp['kodas'])){
					// sudarome klaidų pranešimą
					$formErrors = "Pirkėjas su įvestu kodu jau egzistuoja.";
					// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
					$fields = $_POST;
				} else{
				
					// įrašome naują pirkėją
					$pirkejasObj->insertPirkejas($data);
				}
				
			}
			if($formErrors == null) {
				// nukreipiame vartotoją į pirkėjų puslapį
				header("Location: index.php?module={$module}");
				die();
			}
		}
		else {
			// gauname klaidų pranešimą
			$formErrors = $validator->getErrorHTML();
			
			// laukų reikšmių kintamajam priskiriame įvestų laukų reikšmes
			$fields = $_POST;
		}
	} else {
		// tikriname, ar nurodytas elemento id. Jeigu taip, išrenkame elemento duomenis ir jais užpildome formos laukus.
		if(!empty($id)) {
			// išrenkame klientą
			$fields = $pirkejasObj->getPirkejas($id);
			$fields['editing'] = 1;
		}
	}
?>
<ul id="pagePath">
	<li><a href="index.php">Pradžia</a></li>
	<li><a href="index.php?module=<?php echo $module; ?>">Pirkėjai</a></li>
	<li><?php if(!empty($id)) echo "Pirkėjo redagavimas"; else echo "Naujas pirkėjas"; ?></li>
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
			<legend>Pirkėjo informacija</legend>
				<p>
					<label class="field" for="kodas">Kodas<?php echo in_array('kodas', $required) ? '<span> *</span>' : ''; ?></label>
					<?php if(!isset($fields['editing'])) { ?>
						<input type="text" id="kodas" name="kodas" class="textbox-150" value="<?php echo isset($fields['kodas']) ? $fields['kodas'] : ''; ?>" />
						<?php if(key_exists('kodas', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['kodas']} simb.)</span>"; ?>
					<?php } else { ?>
						<span class="input-value"><?php echo $fields['kodas']; ?></span>
						<input type="hidden" name="editing" value="1" />
						<input type="hidden" name="kodas" value="<?php echo $fields['kodas']; ?>" />
					<?php } ?>
				</p>
			<p>
				<label class="field" for="prisijungimoVardas">Prisijungimo vardas<?php echo in_array('prisijungimoVardas', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="prisijungimoVardas" name="prisijungimoVardas" class="textbox-150" value="<?php echo isset($fields['prisijungimoVardas']) ? $fields['prisijungimoVardas'] : ''; ?>" />
				<?php if(key_exists('prisijungimoVardas', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['prisijungimoVardas']} simb.)</span>"; ?>
			</p>
				<p>
				<label class="field" for="slaptazodis">Slaptažodis<?php echo in_array('slaptazodis', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="slaptazodis" name="slaptazodis" class="textbox-150" value="<?php echo isset($fields['slaptazodis']) ? $fields['slaptazodis'] : ''; ?>" />
				<?php if(key_exists('slaptazodis', $maxLengths)) echo "<span class='max-len'>(iki {$maxLengths['slaptazodis']} simb.)</span>"; ?>
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
			<p>
				<label class="field" for="adresas">Adresas<?php echo in_array('adresas', $required) ? '<span> *</span>' : ''; ?></label>
				<input type="text" id="adresas" name="adresas" class="textbox-150" value="<?php echo isset($fields['adresas']) ? $fields['adresas'] : ''; ?>" />
			</p>
		</fieldset>
		<p class="required-note">* pažymėtus laukus užpildyti privaloma</p>
		<p>
			<input type="submit" class="submit" name="submit" value="Išsaugoti">
		</p>
	</form>
</div>