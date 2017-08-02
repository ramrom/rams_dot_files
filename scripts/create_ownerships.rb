require 'csv'

class CreateOwnerships
  def self.call(file_path, eff_date)
    content = File.read(file_path)
    effective_date = Date.parse(eff_date)
    
    entities  = {}
    netcredit = LegalEntity['netcredit']
    
    csv = CSV.new(content, headers: true)
    csv.each.each_slice(100) do |slice|
      OwnershipTransfer.transaction do
        transfers = slice.map do |row|
          entity = entities.fetch(row['entity']) do |key|
            entities[key] = LegalEntity.find_or_create_by!(legal_entity: key)
          end
    
          OwnershipTransfer.new(
            loan_id: row['loan_id'],
            transferred_from_entity_id: netcredit.id,
            transferred_to_entity_id: entity.id,
            effective_date: effective_date,
            percentage: 1,
            cost: 0
          )
        end
   
        OwnershipTransfer.import(transfers)
      end
    end
  end
end
