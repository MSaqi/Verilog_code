// Setting AXI Adapter with AXI VIP 
// Copy right reserved 



 aaxi_uvm_mem_adapter   reg2axi_adapter       ;  
 aaxi_uvm_agent         axi_mst_agent   ;
/// Creating agent 

// REG MODEL Setting
reg_model    = new("top_reg_model");    
reg_model.build();
reg_model.lock_model();
hdl_path = "dch_tb_top";
reg_model.set_hdl_path_root(hdl_path);
reg_model.set_coverage(UVM_CVR_ALL);
uvm_config_db #(top_reg_model)::set(null, "*", "reg_model", reg_model);
/// Creating axi agent
axi_mst_agent = aaxi_uvm_agent::type_id::create("axi_mst_agent",this);
avery_vip_master_agent(port_id,axi_mst_agent , "axi_mst_agent" , axi3_vers ); 
/// creating Reg adapter
 reg2axi_adapter = aaxi_uvm_mem_adapter::type_id::create("reg2axi_adapter");   
 reg2axi_adapter.vers = axi3_vers;
 reg2axi_adapter.en_n_bits = 1;
 reg2axi_adapter.supports_byte_enable = 1;
/// Setting VIP agent 
`uvm_info(class_name, $sformatf("Configuring axi_mst_agent for env "), UVM_MEDIUM) 
`VIP_4B_BFM_CFG(axi_mst_agent);
axi_mst_agent.driver.vers = axi3_vers;
axi_mst_agent.driver.enable_coverage = 0 ;
// Maappping the VIP agent to REG model 
reg_model.default_map.set_sequencer(axi_mst_agent.sequencer,reg2axi_adapter); 
reg_model.default_map.set_auto_predict(0);
