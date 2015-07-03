s = Substance.where(name: 'Phencyclidine').first
SubstanceAlternateName.create(substance_id: s.id, name: 'PCP')

s = Substance.where(name: 'Methylphenobarbital').first
SubstanceAlternateName.create(substance_id: s.id, name: 'Mephobarbital')

s = Substance.where(name: 'Dimethyltryptamine').first
SubstanceAlternateName.create(substance_id: s.id, name: 'DMT')

s = Substance.where(name: 'Diethyltryptamine').first
SubstanceAlternateName.create(substance_id: s.id, name: 'DMT')

s = Substance.where(name: 'Nabilone').first
s.first_scheduled_date = "1987-04-07".to_date
s.save