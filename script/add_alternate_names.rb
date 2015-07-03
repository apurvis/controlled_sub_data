s = Substance.where(name: 'Phencyclidine').first
SubstanceAlternateName.create(substance_id: s.id, name: 'PCP')
