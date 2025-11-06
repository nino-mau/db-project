-- Placeholder seed data for testing
-- Users (admin, vet, regular user)
INSERT INTO
  public."user" (
    id,
    name,
    email,
    phone,
    password,
    role,
    created_at
  )
VALUES
  (
    '550e8400-e29b-41d4-a716-446655440001',
    'Admin User',
    'admin@test.com',
    '555-0001',
    'hashed_password_123',
    'admin',
    CURRENT_TIMESTAMP
  ),
  (
    '550e8400-e29b-41d4-a716-446655440002',
    'Dr. Sarah Vet',
    'sarah.vet@test.com',
    '555-0002',
    'hashed_password_456',
    'vet',
    CURRENT_TIMESTAMP
  ),
  (
    '550e8400-e29b-41d4-a716-446655440003',
    'John Volunteer',
    'john@test.com',
    '555-0003',
    'hashed_password_789',
    'volunteer',
    CURRENT_TIMESTAMP
  ),
  (
    '550e8400-e29b-41d4-a716-446655440004',
    'Jane Donor',
    'jane.donor@test.com',
    '555-0004',
    'hashed_password_abc',
    'user',
    CURRENT_TIMESTAMP
  );

-- Get animal type IDs for reference (using first few from animal_type table)
-- We'll get Dog, Cat, and Rabbit for our test animals
-- Animals (3 test animals with medical files)
INSERT INTO
  public.animal (
    id,
    name,
    age,
    sex,
    type_id,
    race_id,
    description,
    created_at
  )
VALUES
  (
    '650e8400-e29b-41d4-a716-446655440001',
    'Max',
    3,
    'male',
    (
      SELECT
        id
      FROM
        public.animal_type
      WHERE
        name = 'Dog'
      LIMIT
        1
    ),
    NULL,
    'Friendly golden retriever, rescued from streets',
    CURRENT_TIMESTAMP
  ),
  (
    '650e8400-e29b-41d4-a716-446655440002',
    'Whiskers',
    2,
    'female',
    (
      SELECT
        id
      FROM
        public.animal_type
      WHERE
        name = 'Cat'
      LIMIT
        1
    ),
    NULL,
    'Orange tabby cat, very playful',
    CURRENT_TIMESTAMP
  ),
  (
    '650e8400-e29b-41d4-a716-446655440003',
    'Fluffy',
    1,
    'male',
    (
      SELECT
        id
      FROM
        public.animal_type
      WHERE
        name = 'Rabbit'
      LIMIT
        1
    ),
    NULL,
    'White rabbit, calm personality',
    CURRENT_TIMESTAMP
  );

-- Medical files for animals
INSERT INTO
  public.medical_file (
    id,
    vaccination_rate,
    description,
    animal_id,
    health_status,
    created_at
  )
VALUES
  (
    '750e8400-e29b-41d4-a716-446655440001',
    75,
    'Initial health check done',
    '650e8400-e29b-41d4-a716-446655440001',
    'healthy',
    CURRENT_TIMESTAMP
  ),
  (
    '750e8400-e29b-41d4-a716-446655440002',
    60,
    'Needs vaccination update',
    '650e8400-e29b-41d4-a716-446655440002',
    'healthy',
    CURRENT_TIMESTAMP
  ),
  (
    '750e8400-e29b-41d4-a716-446655440003',
    100,
    'Up to date on all vaccines',
    '650e8400-e29b-41d4-a716-446655440003',
    'healthy',
    CURRENT_TIMESTAMP
  );

-- Adoption files for animals
INSERT INTO
  public.adoption_file (
    id,
    vaccination_rate,
    description,
    animal_id,
    created_at
  )
VALUES
  (
    '850e8400-e29b-41d4-a716-446655440001',
    75,
    'Ready for adoption',
    '650e8400-e29b-41d4-a716-446655440001',
    CURRENT_TIMESTAMP
  ),
  (
    '850e8400-e29b-41d4-a716-446655440002',
    60,
    'Will be ready soon',
    '650e8400-e29b-41d4-a716-446655440002',
    CURRENT_TIMESTAMP
  );

-- Vaccine types
INSERT INTO
  public.vaccine_type (id, name, created_at)
VALUES
  (
    '950e8400-e29b-41d4-a716-446655440001',
    'Rabies',
    CURRENT_TIMESTAMP
  ),
  (
    '950e8400-e29b-41d4-a716-446655440002',
    'DHPP (Dog)',
    CURRENT_TIMESTAMP
  ),
  (
    '950e8400-e29b-41d4-a716-446655440003',
    'FVRCP (Cat)',
    CURRENT_TIMESTAMP
  );

-- Vaccinations
INSERT INTO
  public.vaccination (
    id,
    vaccine_id,
    status,
    description,
    datetime,
    vet_id,
    medical_file_id,
    created_at
  )
VALUES
  (
    'a50e8400-e29b-41d4-a716-446655440001',
    '950e8400-e29b-41d4-a716-446655440001',
    'done',
    'Rabies vaccination for Max',
    NOW () - INTERVAL '30 days',
    '550e8400-e29b-41d4-a716-446655440002',
    '750e8400-e29b-41d4-a716-446655440001',
    CURRENT_TIMESTAMP
  ),
  (
    'a50e8400-e29b-41d4-a716-446655440002',
    '950e8400-e29b-41d4-a716-446655440003',
    'upcoming',
    'Feline vaccine for Whiskers',
    NOW () + INTERVAL '7 days',
    '550e8400-e29b-41d4-a716-446655440002',
    '750e8400-e29b-41d4-a716-446655440002',
    CURRENT_TIMESTAMP
  );

-- Adoption requests
INSERT INTO
  public.adoption_request (
    id,
    status,
    description,
    requester_note,
    requester_id,
    adoption_file_id,
    created_at
  )
VALUES
  (
    'b50e8400-e29b-41d4-a716-446655440001',
    'pending',
    'Interested in adopting Max',
    'I have a big yard and experience with dogs',
    '550e8400-e29b-41d4-a716-446655440004',
    '850e8400-e29b-41d4-a716-446655440001',
    CURRENT_TIMESTAMP
  );

-- Behavior types
INSERT INTO
  public.behavior_type (id, name, description, created_at)
VALUES
  (
    'c50e8400-e29b-41d4-a716-446655440001',
    'Friendly',
    'Gets along well with people and other animals',
    CURRENT_TIMESTAMP
  ),
  (
    'c50e8400-e29b-41d4-a716-446655440002',
    'Shy',
    'Needs time to warm up to strangers',
    CURRENT_TIMESTAMP
  ),
  (
    'c50e8400-e29b-41d4-a716-446655440003',
    'Energetic',
    'Very active and playful',
    CURRENT_TIMESTAMP
  );

-- Behavior files for animals
INSERT INTO
  public.behavior_file (id, animal_id, behavior_type_id, note, created_at)
VALUES
  (
    'd50e8400-e29b-41d4-a716-446655440001',
    '650e8400-e29b-41d4-a716-446655440001',
    'c50e8400-e29b-41d4-a716-446655440001',
    'Max loves to play fetch and is great with kids',
    CURRENT_TIMESTAMP
  ),
  (
    'd50e8400-e29b-41d4-a716-446655440002',
    '650e8400-e29b-41d4-a716-446655440002',
    'c50e8400-e29b-41d4-a716-446655440003',
    'Whiskers is very active and loves to climb',
    CURRENT_TIMESTAMP
  );

-- Campaigns for fundraising
INSERT INTO
  public.campaign (
    id,
    title,
    description,
    goal_amount,
    status,
    start_date,
    end_date,
    created_at
  )
VALUES
  (
    'e50e8400-e29b-41d4-a716-446655440001',
    'Summer Care Initiative',
    'Help us care for rescued animals during summer',
    5000,
    'active',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '30 days',
    CURRENT_TIMESTAMP
  ),
  (
    'e50e8400-e29b-41d4-a716-446655440002',
    'Medical Equipment Fund',
    'Raise funds for veterinary equipment',
    10000,
    'active',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '60 days',
    CURRENT_TIMESTAMP
  );

-- Donations
INSERT INTO
  public.donation (
    id,
    amount,
    means,
    donator_id,
    campaign_id,
    donated_at,
    created_at
  )
VALUES
  (
    'f50e8400-e29b-41d4-a716-446655440001',
    500,
    'credit_card',
    '550e8400-e29b-41d4-a716-446655440004',
    'e50e8400-e29b-41d4-a716-446655440001',
    CURRENT_DATE,
    CURRENT_TIMESTAMP
  ),
  (
    'f50e8400-e29b-41d4-a716-446655440002',
    1000,
    'bank_transfer',
    '550e8400-e29b-41d4-a716-446655440003',
    'e50e8400-e29b-41d4-a716-446655440002',
    CURRENT_DATE - INTERVAL '5 days',
    CURRENT_TIMESTAMP
  );

-- Medical care types
INSERT INTO
  public.medical_care_type (id, name, description, created_at)
VALUES
  (
    '050e8400-e29b-41d4-a716-446655440001',
    'Check-up',
    'General health examination',
    CURRENT_TIMESTAMP
  ),
  (
    '050e8400-e29b-41d4-a716-446655440002',
    'Wound Treatment',
    'Treatment for injuries and wounds',
    CURRENT_TIMESTAMP
  ),
  (
    '050e8400-e29b-41d4-a716-446655440003',
    'Dental Cleaning',
    'Professional tooth cleaning',
    CURRENT_TIMESTAMP
  );

-- Medical care records
INSERT INTO
  public.medical_care (
    id,
    type_id,
    status,
    description,
    datetime,
    vet_id,
    medical_file_id,
    created_at
  )
VALUES
  (
    '150e8400-e29b-41d4-a716-446655440001',
    '050e8400-e29b-41d4-a716-446655440001',
    'done',
    'Regular check-up for Max',
    NOW () - INTERVAL '15 days',
    '550e8400-e29b-41d4-a716-446655440002',
    '750e8400-e29b-41d4-a716-446655440001',
    CURRENT_TIMESTAMP
  ),
  (
    '150e8400-e29b-41d4-a716-446655440002',
    '050e8400-e29b-41d4-a716-446655440003',
    'upcoming',
    'Dental cleaning scheduled for Whiskers',
    NOW () + INTERVAL '10 days',
    '550e8400-e29b-41d4-a716-446655440002',
    '750e8400-e29b-41d4-a716-446655440002',
    CURRENT_TIMESTAMP
  );

-- Injury types
INSERT INTO
  public.injury_type (id, name, description, created_at)
VALUES
  (
    '250e8400-e29b-41d4-a716-446655440001',
    'Fracture',
    'Broken bone',
    CURRENT_TIMESTAMP
  ),
  (
    '250e8400-e29b-41d4-a716-446655440002',
    'Laceration',
    'Deep cut or wound',
    CURRENT_TIMESTAMP
  ),
  (
    '250e8400-e29b-41d4-a716-446655440003',
    'Burn',
    'Heat-related injury',
    CURRENT_TIMESTAMP
  );

-- Medicine types
INSERT INTO
  public.medicine_type (id, name, description, created_at)
VALUES
  (
    '350e8400-e29b-41d4-a716-446655440001',
    'Antibiotics',
    'For bacterial infections',
    CURRENT_TIMESTAMP
  ),
  (
    '350e8400-e29b-41d4-a716-446655440002',
    'Pain Reliever',
    'For pain management',
    CURRENT_TIMESTAMP
  ),
  (
    '350e8400-e29b-41d4-a716-446655440003',
    'Anti-inflammatory',
    'To reduce swelling',
    CURRENT_TIMESTAMP
  );
