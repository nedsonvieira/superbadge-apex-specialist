public with sharing class EquipmentDTO {
    
    public String id;
    public Boolean replacement = true;
    public Double quantity;
    public String name;
    public Integer maintenanceperiod;
    public Integer lifespan;
    public Integer cost;
    public String sku;
    
    public static List<EquipmentDTO> fromJson(String jsonString) {
        try {
            jsonString = jsonString.replace('_id', 'id');
            return (List<EquipmentDTO>) JSON.deserialize(jsonString, List<EquipmentDTO>.class);
        } catch (Exception e) {
            System.debug('Erro na conversão JSON: ' + e.getMessage());
            return new List<EquipmentDTO>();
        }
    }
}