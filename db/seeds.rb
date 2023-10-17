# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

health_center = HealthCenter.create(name: 'Spaarne Gasthuis', reference_code: 'SG_HZ')

Caregiver.create([
  { health_center: health_center, phone: '123456' },
  { health_center: health_center, phone: '234567' },
  { health_center: health_center, phone: '345678' }
])

patient1 = Patient.create({
  first_name: 'Luisa',
  last_name: 'Caceres',
  additional_information: 'Had a hip replacement. Saves the key under the front rug.',
  health_center: health_center
})
patient2 = Patient.create({
  first_name: 'Pedro',
  last_name: 'Perez',
  additional_information: 'Biker. Near neighbors have a key.',
  health_center: health_center
})

Address.create([
  {
    street: 'Italielaan',
    city: 'Haarlem',
    postal_code: '2034 BX',
    patient: patient1
  },
  {
    street: 'Belgielaan 4',
    city: 'Haarlem',
    postal_code: '2034 AX',
    patient: patient2,
  }
])

Device.create([
  {
    sim_sid: 'superCEL000',
    health_center: health_center,
    patient: patient1
  },
  {
    sim_sid: 'VI3j1t0',
    health_center: health_center,
    patient: patient2
  }
])

Alert.create([
  {
    received_at: Time.now,
    received_value: 200,
    alert_type: 2,
    latitude: 52.359988,
    longitud: 4.652951,
    device: Device.first
  },
  {
    received_at: 2.hours.ago,
    received_value: 500,
    alert_type: 1,
    latitude: 52.359965,
    longitud: 4.639595,
    device: Device.second
  }
])